import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';

/// 加载状态
enum LoaderState {
  /// 加载中
  loading,

  /// 加载完成
  finish,

  /// 加载完成，没有更多
  completed,

  /// 空数据
  noData,

  /// 错误
  error,
}

/// 加载器
class Loader extends StatefulWidget {
  ///
  const Loader({
    Key? key,
    required this.controller,
    required this.child,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoad,
    this.onError,
    this.onNoData,
    this.refreshColor,
    this.preloadHeight = 100,
    this.noDataMsg = "暂无数据，点击重试",
    this.errorMsg = "加载错误，点击重试",
    this.physics,
    this.shrinkWrap = false,
  }) : super(key: key);

  /// 滚动组件
  final Widget child;

  /// 刷新回调
  final Future<void> Function()? onRefresh;

  /// 加载回调
  final Function? onLoad;

  /// 错误回调
  final VoidCallback? onError;

  /// 空数据回调
  final VoidCallback? onNoData;

  /// 空数据文案
  final String noDataMsg;

  /// 加载错误文案
  final String errorMsg;

  /// 头
  final List<Widget>? header;

  /// 脚
  final List<Widget>? footer;

  /// 加载颜色
  final Color? refreshColor;

  /// 预加载高度
  final double preloadHeight;

  /// 控制器
  final LoaderController controller;

  /// 物理滚动，若外层是可滚动的登西，比如SingleScrollview、CustomScrollview等，请传 NeverScrollableScrollPhysics
  final ScrollPhysics? physics;

  /// 内容是否延伸 若外层是可滚动的登西，比如SingleScrollview、CustomScrollview等，请传 true
  final bool shrinkWrap;

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  ScrollController scrollController = ScrollController();

  late LoaderController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

    controller.addListener(() {
      setState(() {});
    });

    // if (widget.onRefresh != null) {
    //   Future<dynamic>.delayed(const Duration(milliseconds: 50), () {
    //     widget.onRefresh!();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> slivers = [];

        Widget content;

        switch (controller.state) {
          case LoaderState.loading:
            content = getLoadingView(constraints);
            break;
          case LoaderState.error:
            content = getErrorView(constraints);
            break;
          case LoaderState.noData:
            content = getNoDataView(constraints);
            break;
          case LoaderState.finish:
          case LoaderState.completed:
            slivers = _buildSliversByChild();
            // content = _buildListBodyByChild(slivers, null, null);
            // content = widget.child is ScrollView
            //     ? _buildListBodyByChild(slivers, null, null)
            //     : widget.child;
            content = widget.child is! NestedScrollView &&
                    widget.child is! ExtendedNestedScrollView
                ? _buildListBodyByChild(slivers, null, null)
                : widget.child;
            break;
        }

        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: _handleGlowNotification,
            child: widget.onRefresh == null
                ? content
                : RefreshIndicator(
                    color: widget.refreshColor ?? DSColors.primaryColor,
                    notificationPredicate: (notification) {
                      return true;
                    },
                    onRefresh: _refresh,
                    child: content,
                  ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSliversByChild() {
    Widget? child = widget.child;
    List<Widget> slivers = [];
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        // ignore: invalid_use_of_protected_member
        Widget sliver = child.buildChildLayout(context);
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding!)];
        } else {
          slivers = [sliver];
        }
      } else {
        // ignore: invalid_use_of_protected_member
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else if (child is SingleChildScrollView) {
      if (child.child != null) {
        slivers = [
          SliverPadding(
            sliver: SliverList(
              delegate: SliverChildListDelegate([child.child!]),
            ),
            padding: child.padding ?? EdgeInsets.zero,
          ),
        ];
      }
    } else if (child is! Scrollable && child is! NestedScrollView) {
      slivers = [
        SliverToBoxAdapter(
          child: child,
        )
      ];
    }
    if (widget.header != null) {
      slivers.insert(
          0,
          SliverToBoxAdapter(
            child: Column(
              children: widget.header!,
            ),
          ));
    }
    if (widget.footer != null) {
      slivers.add(SliverToBoxAdapter(
        child: Column(
          children: widget.footer!,
        ),
      ));
    }
    if (widget.onLoad != null) {
      slivers.add(SliverToBoxAdapter(
        child: getLoadFooter(),
      ));
    }
    return slivers;
  }

  // 通过child构建列表组件
  Widget _buildListBodyByChild(
      List<Widget> slivers, Widget? header, Widget? footer) {
    Widget child = widget.child;
    if (child is ScrollView) {
      return CustomScrollView(
        cacheExtent: child.cacheExtent,
        key: child.key,
        scrollDirection: child.scrollDirection,
        semanticChildCount: child.semanticChildCount,
        slivers: slivers,
        dragStartBehavior: child.dragStartBehavior,
        reverse: child.reverse,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
      );
    } else if (child is SingleChildScrollView) {
      return CustomScrollView(
        scrollDirection: child.scrollDirection,
        slivers: slivers,
        dragStartBehavior: child.dragStartBehavior,
        reverse: child.reverse,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
      );
    } else if (child is Scrollable) {
      return Scrollable(
        axisDirection: child.axisDirection,
        semanticChildCount: child.semanticChildCount,
        dragStartBehavior: child.dragStartBehavior,
        viewportBuilder: (context, position) {
          Viewport viewport =
              child.viewportBuilder(context, position) as Viewport;
          return viewport;
        },
      );
    } else {
      return CustomScrollView(
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        slivers: slivers,
      );
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.extentAfter >= 50) {
      // if (widget.onLoad != null &&
      //     controller.state != LoaderState.completed &&
      //     !controller.isLoading) {
      if (widget.onLoad != null &&
          controller.state == LoaderState.finish &&
          !controller.isLoading) {
        controller.isLoading = true;
        widget.onLoad!();
      }
    }

    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    return false;
  }

  Future<void> _refresh() async {
    controller.loadEnd.value = false;
    controller.loading();
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }
  }

  /// 加载组件
  Widget getLoadingView(BoxConstraints constraints) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight + 1,
            child: Center(
              child: Image.asset(
                "assets/images/icon_loading.png",
                width: 100,
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 空数据组件
  Widget getNoDataView(BoxConstraints constraints) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              if (widget.onNoData != null) {
                widget.onError!();
              } else if (widget.onRefresh != null) {
                widget.onRefresh!();
              }
            },
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight + 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/icon_no_data.png",
                      width: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "暂无数据，点击重新加载",
                      style: TextStyle(color: DSColors.title),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 错误组件
  Widget getErrorView(BoxConstraints constraints) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              if (widget.onError != null) {
                widget.onError!();
              } else if (widget.onRefresh != null) {
                widget.onRefresh!();
              }
            },
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight + 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/icon_error.png",
                      width: 200,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "加载错误，点击重试",
                      style: TextStyle(color: DSColors.title),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 内容
  List<Widget> getContent() {
    Widget? child = widget.child;

    List<Widget> slivers = [];
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        // ignore: invalid_use_of_protected_member
        Widget sliver = child.buildChildLayout(context);
        if (child is ListView) {
          sliver = SliverToBoxAdapter(
            child: child,
          );
        }
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding!)];
        } else {
          slivers = [sliver];
        }
      } else {
        // ignore: invalid_use_of_protected_member
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else {
      slivers = [
        SliverToBoxAdapter(
          child: child,
        )
      ];
    }

    if (widget.header != null) {
      slivers.insert(
          0,
          SliverToBoxAdapter(
            child: Column(
              children: widget.header!,
            ),
          ));
    }
    if (widget.footer != null) {
      slivers.add(SliverToBoxAdapter(
        child: Column(
          children: widget.footer!,
        ),
      ));
    }
    if (widget.onLoad != null) {
      slivers.add(SliverToBoxAdapter(
        child: getLoadFooter(),
      ));
    }

    return slivers;
  }

  Widget getLoadFooter() {
    return SizedBox(
      height: 50,
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: controller.loadEnd,
          builder: (BuildContext context, bool value, Widget? child) {
            return Text(
              value ? "我是有底线的-------" : "正在加载...",
              style: TextStyle(color: DSColors.title, fontSize: 14),
            );
          },
        ),
      ),
    );
  }
}

/// 加载控制器
class LoaderController extends ChangeNotifier {
  /// 状态
  LoaderState state = LoaderState.loading;

  /// 错误文案
  String errorMsg = "";

  /// 空数据文案
  String noDataMsg = "";

  /// 是否加载完毕
  final loadEnd = ValueNotifier<bool>(false);

  /// 是否正在加载
  bool isLoading = false;

  /// 设置listview状态
  void setLoadState(LoaderState state) {
    this.state = state;
  }

  /// 加载出错
  void loadError({String? msg}) {
    setLoadState(LoaderState.error);
    if (msg != null) {
      errorMsg = msg;
    }
    notifyListeners();
  }

  /// 加载完成
  void loadFinish({dynamic data, bool noMore = false}) {
    final temp = LoaderState.values[state.index];
    if (data != null) {
      if (data is List) {
        if (temp == LoaderState.loading && data.isEmpty) {
          setLoadState(LoaderState.noData);
        } else if (noMore) {
          loadEnd.value = true;
          setLoadState(LoaderState.completed);
        } else {
          loadEnd.value = false;
          setLoadState(LoaderState.finish);
        }
      } else {
        loadEnd.value = true;
        setLoadState(LoaderState.completed);
      }
    } else {
      loadEnd.value = true;
      setLoadState(LoaderState.completed);
    }
    isLoading = false;
    if (temp != state) {
      notifyListeners();
    }
  }

  /// 加载无数据
  void loadNullData({String? msg}) {
    setLoadState(LoaderState.noData);
    if (msg != null) {
      noDataMsg = msg;
    }
    notifyListeners();
  }

  /// 正在加载
  void loading() {
    setLoadState(LoaderState.loading);
    notifyListeners();
  }
}
