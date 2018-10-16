package;

import haxe.Timer;
import tink.state.*;

using tink.CoreApi;

class AutoBench {
    var items:Array<SOPair<Int>>;

    public function new(count:Int, depth:Int) {
        items = [];
        for (i in 0...count) {
            var s = new State<Int>(i),
                o = s.observe();
            for (j in 0...depth)
                o = wrap(o);
            items[i] = new SOPair(s, o);
        }
    }

    public function run(sets:Int, reps:Int):Future<Float> {
        var totalTime = 0.0;
        var sum = 0.0;
        var iterations;
        function iter() {
            function handle(v:Int) {
                sum += v;
            }
            iterations = reps;
            while (iterations-- > 0) {
                for (item in items) {
                    var link = item.b.bind({direct: true}, handle);
                    item.a.set(iterations);
                    link.cancel();
                }
            }
        }
        function measure(cb) {
            var startTime = js.Node.process.hrtime();
            iter();
            var iterTime = js.Node.process.hrtime(startTime);
            totalTime += iterTime[0] + iterTime[1] / 1e9;
            if (--sets == 0) cb(totalTime);
            else Timer.delay(measure.bind(cb), 0);
        }
        return Future.async(measure);
    }

    static function wrap<T>(o:Observable<T>):Observable<T>
        return Observable.auto(function () return o.value);
}

private typedef SOPair<T> = Pair<State<T>, Observable<T>>;
