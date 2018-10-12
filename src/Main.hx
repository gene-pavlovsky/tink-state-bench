package;

using tink.CoreApi;

class Main {
    static function main() {
        var bench = new AutoBench(10, 1);
        bench.run()
            .handle(function (o) switch o {
                case Success(res): trace('Success: $res');
                case Failure(err): trace('Failure: $err');
            });
    }
}
