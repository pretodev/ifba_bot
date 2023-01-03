import 'package:puppeteer/puppeteer.dart';

import '../../data/scrapping/scrapping_browser.dart';
import '../error.dart';

class PupperteerBrowserError extends ExternalError {
  PupperteerBrowserError({
    required super.message,
    required super.service,
    required super.stackTrace,
  });
}

class PupperteerBrowser implements ScrappingBrowser {
  Browser? _browser;

  @override
  Browser get instance {
    if (_browser == null) {
      throw PupperteerBrowserError(
        message: 'PupperteerBrowser não foi inicializado.',
        service: 'Pupperteer',
        stackTrace: StackTrace.current,
      );
    }
    return _browser!;
  }

  @override
  Future<void> open() async {
    _browser = await puppeteer.launch();
  }

  @override
  Future<void> close() async {
    await _browser?.close();
  }
}
