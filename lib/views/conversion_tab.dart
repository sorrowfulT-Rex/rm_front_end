import 'package:dartz/dartz.dart' as fn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rm_front_end/components/button.dart';
import 'package:rm_front_end/constants/my_markdown_texts.dart';
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/controllers/input_manager.dart';
import 'package:rm_front_end/models/decode_data.dart';
import 'package:rm_front_end/utilities/downloader.dart';
import 'package:rm_front_end/services/rm_api.dart';

class ConversionTab extends StatefulWidget {
  const ConversionTab({super.key});

  @override
  State<ConversionTab> createState() => _ConversionTabState();
}

class _ConversionTabState extends State<ConversionTab>
    with AutomaticKeepAliveClientMixin<ConversionTab> {
  final decodeInputManager = InputManager<DecodeData>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    decodeInputManager.initState();
    decodeInputManager.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    decodeInputManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final decodeData = decodeInputManager.data;
    final hasValidData = decodeData?.errors.isEmpty == true;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const MarkdownBody(
            data: MyMarkdownTexts.decodeMarkdown,
            fitContent: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: decodeInputManager.textController,
                    decoration: InputDecoration(
                      hintText: decodeInputManager.currentSearchedInput != null
                          ? 'Click "${MyText.convert.text}" to restore the previous input'
                          : null,
                    ),
                    maxLines: null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: decodeInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.primary,
                  onPressed: () => decodeInputManager.onQuery(RMAPI.decode),
                  child: Row(
                    children: [
                      Text(MyText.convert.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: hasValidData,
                  colour: Theme.of(context).colorScheme.secondary,
                  onPressed: () => Downloader.saveAsZip(
                    'decoded.zip',
                    [
                      fn.Tuple2(
                        'decoded_machine.rm',
                        '${decodeData?.regMach}',
                      ),
                      fn.Tuple2('response.json', '${decodeData?.json}')
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(MyText.download.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.download_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: hasValidData || decodeInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.tertiary,
                  onPressed: () => decodeInputManager.onReset(),
                  child: Row(
                    children: [
                      Text(MyText.reset.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.restore_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (decodeData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MarkdownBody(
                data: decodeData.toMarkdown(),
                fitContent: false,
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: MarkdownBody(
              data: MyMarkdownTexts.encodeRMmarkdown,
              fitContent: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    // controller: decodeInputManager.textController,
                    // decoration: InputDecoration(
                    //   hintText: decodeInputManager.currentSearchedInput != null
                    //       ? 'Click "${MyText.convert.text}" to restore the previous input'
                    //       : null,
                    // ),
                    minLines: 5,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
