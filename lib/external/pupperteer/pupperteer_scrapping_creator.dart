import 'scrappings/ifba_type_b_scrapping.dart';

import 'scrappings/ifba_type_a_scrapping.dart';

import '../../core/post_site.dart';
import '../../data/scrapping/scrapping_creator.dart';
import '../../data/scrapping/scrapping.dart';

class PupperteerScrappingCreator implements ScrappingCreator {
  static const scrappingIfbaSamaro = 'scrapping.ifba.samaro';
  static const scrappingIfba = 'scrapping.ifba';
  static const scrappingIfbaPrpgi = 'scrapping.ifba.prpgi';

  @override
  Scrapping fromSite({
    required PostSite site,
  }) {
    switch (site.key) {
      case scrappingIfbaSamaro:
        return IfbaTypeAScrapping(
          site: site,
        );
      case scrappingIfba:
        return IfbaTypeBScrapping(
          site: site,
        );
      case scrappingIfbaPrpgi:
        return IfbaTypeAScrapping(
          site: site,
        );
    }
    throw ScrappingCreatorError(
      'O ID do Site é inválido ou não possui um scrapping',
    );
  }
}
