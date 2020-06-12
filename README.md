# 玩安卓Flutter客户端
# In development

## 项目截图

| <img src="screenshot/home.png" width = "240" height = "427" alt="" align=center /> | <img src="screenshot/drawer.png" width = "240" height = "427" alt="" align=center /> | <img src="screenshot/project.png" width = "240" height = "427" alt="" align=center /> |
| ------ | ------ | ------ |
| <img src="screenshot/navi.png" width = "240" height = "427" alt="" align=center /> | <img src="screenshot/tree.png" width = "240" height = "427" alt="" align=center /> | <img src="screenshot/wx.png" width = "240" height = "427" alt="" align=center /> |
| <img src="screenshot/login.png" width = "240" height = "427" alt="" align=center /> | <img src="screenshot/webview.png" width = "240" height = "427" alt="" align=center /> | <img src="screenshot/search.png" width = "240" height = "427" alt="" align=center /> |

#### request
```
  Http().getTreeList().then((value) {
    _list.clear();
    _list.addAll(value);
  }).whenComplete(() => setState(() {}));
```
```
  // 返回普通List数据
  Future<List<TreeModel>> getTreeList() async {
    Response response = await _dio.get(API.TREE);
    return await checkResult(
        response, (element) => TreeModel.fromJson(element));
  }
```
```
  //返回分页List数据
  Future<BaseListModel<ArticleModel>> getArticleProjectList(int page) async {
    Response response = await _dio.get(
        '${API.ARTICLE_PROJECT_LIST}/$page/json');
    return await checkResult(
        response, (element) => ArticleModel.fromJson(element));
  }
```