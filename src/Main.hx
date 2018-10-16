package;

import haxe.Timer;

class Main {
    static function main() {
        run([
            {o: 100, w: 0, s: 3, r: 100},
            {o: 100, w: 1, s: 3, r: 100},
            {o: 100, w: 3, s: 3, r: 100},
            {o: 100, w: 5, s: 3, r: 100},
            {o: 1000, w: 0, s: 3, r: 100},
            {o: 1000, w: 1, s: 3, r: 100},
            {o: 1000, w: 3, s: 3, r: 100},
            {o: 1000, w: 5, s: 3, r: 100},
        ]);
    }

    static function run(items:Array<Item>) {
        var i = items.shift();

        if (i != null) {
            var bench = new AutoBench(i.o, i.w);
            bench.run(i.s, i.r)
                .handle(function (time) {
                    time /= i.s;
                    trace('observables: ${lpad(i.o, 4)} wrapLevel: ${lpad(i.w, 2)} iterations: ${i.s}x${i.r} avgTime: ${Math.round(time * 1000) / 1000}');
                    Timer.delay(run.bind(items), 0);
                });
        }
    }

    static function lpad<T>(v:T, w:Int):String {
        var s:String = Std.string(v);
        for (i in 0...(w - s.length))
            s = ' ' + s;
        return s;
    }
}

private typedef Item = {o:Int, w:Int, s:Int, r:Int}
