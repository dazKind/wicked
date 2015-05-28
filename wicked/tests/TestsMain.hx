package wicked.tests;

class TestsMain {
	static function main() {
		var runner = new haxe.unit.TestRunner();
        
        runner.add(new TestMathMatrix());
        
        var success = runner.run();

        #if sys
        Sys.exit(success ? 0 : 1);
        #end
	}
}