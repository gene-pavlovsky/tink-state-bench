package;

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

    public function run():Promise<Int> {
        return 1;
    }

    function wrap<T>(o:Observable<T>):Observable<T>
        return Observable.auto(function () return o.value);
}

private typedef SOPair<T> = Pair<State<T>, Observable<T>>;
