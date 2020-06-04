class BaseModel {
  int errorCode;
  String errorMsg;

  BaseModel(this.errorCode, this.errorMsg);
}

class BaseListModel<T> {
  int curPage;
  List<T> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  BaseListModel(this.curPage, this.datas, this.offset, this.over,
      this.pageCount, this.size, this.total);
}
