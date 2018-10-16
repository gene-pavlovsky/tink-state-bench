package;

import js.Node.*;
import haxe.Timer;

class Main {
    static function main() {
        //*
        var args = js.Node.process.argv.slice(2).map(Std.parseInt);
        if (args.length != 4) {
            console.error('Expected 4 arguments');
            process.exit(1);
        }
        run([{
            o: args[0], w: args[1], s: args[2], r: args[3]
        }]);
        /*/
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
        //*/
    }

    static function run(items:Array<Item>) {
        var i = items.shift();

        if (i != null) {
            var bench = new AutoBench(i.o, i.w);
            bench.run(i.s, i.r)
                .handle(function (time) {
                    console.log([
                        'observables: ${lpad(i.o, 4)}',
                        'wrapLevel: ${i.w}',
                        'iterations: ${i.s}x${i.r}',
                        'avgTime: ${Math.round(time * 1000) / 1000}'
                    ].join(" "));
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
