import 'package:bob_mobile/data_type/books.dart';
import 'package:bob_mobile/modelData/add_book_form_data.dart';

class StatusToString {
  Books readBook;
  StatusToString(this.readBook);

  String getStatus() {
    String newStatus;
    if (readBook.status == 0) {
      newStatus = 'Not started';
    }
    if (readBook.status == 1) {
      newStatus = 'Read:1/3';
    }
    if (readBook.status == 2) {
      newStatus = 'Read:2/3';
    }
    if (readBook.status == 3) {
      newStatus = 'Finished!!';
    }
    return newStatus;
  }
}
