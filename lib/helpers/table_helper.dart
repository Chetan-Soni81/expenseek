class TableHelper {
  static final String tblUser = DbEnums.tblUser.toString().split('.').last;
  static final String tblExpense = DbEnums.tblExpense.toString().split('.').last;
  static final String tblCategory = DbEnums.tblCategory.toString().split('.').last;
  static final String tblNote = DbEnums.tblNote.toString().split('.').last;
}

enum DbEnums {
    tblUser,
    tblExpense,
    tblCategory,
    tblNote
}

