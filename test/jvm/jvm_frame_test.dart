import 'package:stack_trace_parser/src/jvm/jvm_frame.dart';
import 'package:test/test.dart';

void main() {
  test('parses normal frame', () {
    final frame = JvmFrame.parse('at org.junit.Assert.fail(Assert.java:86)');
    expect(frame.fileName, 'Assert.java');
    expect(frame.lineNumber, 86);
    expect(frame.method, 'fail');
    expect(frame.package, 'org.junit');
    expect(frame.declaringClass, 'Assert');
    expect(frame.skippedFrames, null);
    expect(frame.isNativeMethod, false);
  });

  test('parses normal frame with leading white space', () {
    final frame = JvmFrame.parse('	at org.junit.Assert.fail(Assert.java:86)');
    expect(frame.fileName, 'Assert.java');
    expect(frame.lineNumber, 86);
    expect(frame.method, 'fail');
    expect(frame.package, 'org.junit');
    expect(frame.declaringClass, 'Assert');
    expect(frame.skippedFrames, null);
    expect(frame.isNativeMethod, false);
  });

  test('parses native method frame', () {
    final frame = JvmFrame.parse(
      'at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)',
    );
    expect(frame.fileName, null);
    expect(frame.lineNumber, null);
    expect(frame.method, 'invoke0');
    expect(frame.package, 'sun.reflect');
    expect(frame.declaringClass, 'NativeMethodAccessorImpl');
    expect(frame.isNativeMethod, true);
    expect(frame.skippedFrames, null);
    expect(frame.toString(),
        'at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)');
  });

  test('parses native more frames frame', () {
    final frame = JvmFrame.parse('          ... 2 more');
    expect(frame.fileName, null);
    expect(frame.lineNumber, null);
    expect(frame.method, null);
    expect(frame.package, null);
    expect(frame.declaringClass, null);
    expect(frame.isNativeMethod, false);
    expect(frame.skippedFrames, 2);
    expect(frame.toString(), '          ... 2 more');
  });

  test('parses a lot of frames', () {
    final lines =
        frames.split('\n').where((element) => element.trim().isNotEmpty);
    for (final line in lines) {
      JvmFrame.parse(line);
    }
  });
}

const frames = '''
	at org.junit.Assert.fail(Assert.java:86)
	at org.junit.Assert.assertTrue(Assert.java:41)
	at org.junit.Assert.assertTrue(Assert.java:52)
	at com.example.bank.BankAccountTest.getNumber(BankAccountTest.java:21)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.junit.runners.model.FrameworkMethod\$1.runReflectiveCall(FrameworkMethod.java:50)
	at org.junit.internal.runners.model.ReflectiveCallable.run(ReflectiveCallable.java:12)
	at org.junit.runners.model.FrameworkMethod.invokeExplosively(FrameworkMethod.java:47)
	at org.junit.internal.runners.statements.InvokeMethod.evaluate(InvokeMethod.java:17)
	at org.junit.runners.ParentRunner.runLeaf(ParentRunner.java:325)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:78)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:57)
	at org.junit.runners.ParentRunner\$3.run(ParentRunner.java:290)
	at org.junit.runners.ParentRunner\$1.schedule(ParentRunner.java:71)
	at org.junit.runners.ParentRunner.runChildren(ParentRunner.java:288)
	at org.junit.runners.ParentRunner.access\$000(ParentRunner.java:58)
	at org.junit.runners.ParentRunner\$2.evaluate(ParentRunner.java:268)
	at org.junit.runners.ParentRunner.run(ParentRunner.java:363)
	at org.apache.maven.surefire.junit4.JUnit4TestSet.execute(JUnit4TestSet.java:53)
	at org.apache.maven.surefire.junit4.JUnit4Provider.executeTestSet(JUnit4Provider.java:123)
	at org.apache.maven.surefire.junit4.JUnit4Provider.invoke(JUnit4Provider.java:104)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.apache.maven.surefire.util.ReflectionUtils.invokeMethodWithArray(ReflectionUtils.java:164)
	at org.apache.maven.surefire.booter.ProviderFactory\$ProviderProxy.invoke(ProviderFactory.java:110)
	at org.apache.maven.surefire.booter.SurefireStarter.invokeProvider(SurefireStarter.java:175)
	at org.apache.maven.surefire.booter.SurefireStarter.runSuitesInProcessWhenForked(SurefireStarter.java:107)
	at org.apache.maven.surefire.booter.ForkedBooter.main(ForkedBooter.java:68)
''';
