import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/common/not_found_message.dart';

class SearchPage extends StatefulWidget {
  // use for return value when user select a result and close the search page
  final String title;
  final String searchLabel;
  final String searchPlaceholder;
  final Widget? sideDisplay;
  final Widget Function(dynamic result) resultWidgetFunction;
  final double? customResultSize;
  final Future<void> Function(
      String value,
      Function(List<dynamic>) updateResults,
      CancelToken? cancelToken) searchCallback;

  const SearchPage(
      {super.key,
      required this.title,
      required this.searchLabel,
      required this.searchPlaceholder,
      required this.resultWidgetFunction,
      required this.searchCallback,
      this.sideDisplay,
      this.customResultSize});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic>? _results;
  String _input = '';
  // Declare a Timer variable for debounce
  Timer? _debounce;
  // Declare a CancelToken variable for canceling the search request
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _noSearchResults();
  }

  void _noSearchResults() {
    Future.microtask(() async {
      await widget.searchCallback("", (results) {
        if (!mounted) return;
        setState(() {
          _results = results;
        });
      }, _cancelToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Heading(
          title: widget.title,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              UnderlineTextField(
                  label: widget.searchLabel,
                  icon: FontAwesomeIcons.magnifyingGlass,
                  placeholder: widget.searchPlaceholder,
                  onChange: _onSearchFieldChanged),
              if (widget.sideDisplay != null) ...[
                widget.sideDisplay!,
                const Divider()
              ],
              Expanded(
                child: ((_results ?? []).isNotEmpty && _results != null)
                    ? GridView.count(
                        childAspectRatio: widget.customResultSize ?? 1.0,
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(2.0),
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        children: _results!
                            .map(
                                (result) => widget.resultWidgetFunction(result))
                            .toList())
                    : Container(
                        child: _results == null
                            ? Text("Type to search...",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                maxLines: 2)
                            : Center(
                                child: NotFoundMessage(
                                message: 'No results for "$_input"',
                              ))),
              )
            ])));
  }

  /// Handles user entering text into the search field. We kick off a search for
  /// every letter typed.
  _onSearchFieldChanged(String value) async {
    // Cancel the existing timer if it is set
    _debounce?.cancel();
    // Cancel the previous request if a new search starts
    _cancelToken?.cancel();

    // Set a new timer with a 500ms (or your desired) delay
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      setState(() {
        _input = value;
      });

      // if (value.isEmpty || value.trim() == '') {
      //   // null is a sentinal value that allows us more control the UI
      //   // for a better user experience. instead of showing 'No results for ''",
      //   // if this is null, it will just show nothing
      //   if (!mounted) return;
      //   // setState(() {
      //   //   _results = null;
      //   // });
      //   return;
      // }

      _cancelToken = CancelToken();

      await widget.searchCallback(value, (results) {
        if (!mounted) return;
        setState(() {
          _results = results;
        });
      }, _cancelToken);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cancelToken?.cancel();
    super.dispose();
  }
}
