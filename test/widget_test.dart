import 'package:flutter_test/flutter_test.dart';

import 'package:voice_rec/main.dart';

void main() {
  test('Testing netflix deep linking Url', () {
    final stringTest = StringTest();

    stringTest.deepUrl();

    print(stringTest.newUrl);

    expect(stringTest.newUrl, 'nflx://www.netflix.com/' + stringTest.netflixMovie);
  });
}
