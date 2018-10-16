package;

import js.Node.*;
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
        var runs = sets + 2; // 2 extra "dry run" sets
        var totalTime = 0.0;
        var iterations;
        var sum = 0.0;

        function handle(v:Int)
            sum += v;
        for (item in items)
            item.b.bind({direct: true}, handle);

        function iter() {
            iterations = reps;
            while (iterations-- > 0)
                for (item in items)
                    item.a.set(iterations);
        }

        function measure(cb) {
            if (runs > sets) iter();
            else {
                var time = process.hrtime();
                iter();
                time = process.hrtime(time);
                totalTime += time[0] + time[1] * 1e-9;
            }
            if (--runs == 0) cb(totalTime / sets);
            else Timer.delay(measure.bind(cb), 0);
        }
        
        return Future.async(measure);
    }

    static function wrap<T>(o:Observable<T>):Observable<T>
        return Observable.auto(function () return o.value);
}

private typedef SOPair<T> = Pair<State<T>, Observable<T>>;
