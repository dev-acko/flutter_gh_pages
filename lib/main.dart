import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// name: Flutter Size Check

// on:
//   push:
//     branches: [main]
//   pull_request:

// jobs:
//   size-check:
//     runs-on: ubuntu-latest

//     steps:
//       - name: Checkout repo
//         uses: actions/checkout@v4
//         with:
//           fetch-depth: 2

//       - name: Set up Flutter
//         uses: subosito/flutter-action@v2
//         with:
//           flutter-version: '3.29.3'  # Replace with your local Flutter version
//           channel: stable

//       - name: Confirm Flutter Version
//         run: flutter --version

//       - name: Get dependencies
//         run: flutter pub get

//       - name: Build APK (release) for single ABI
//         run: flutter build apk --release --target-platform android-arm64

//       - name: Get APK size
//         id: apk_size
//         run: |
//           APK_PATH=$(find build/app/outputs/flutter-apk/ -name "*.apk" | head -n 1)
//           SIZE=$(stat -c %s "$APK_PATH")
//           echo "apk_size=$SIZE" >> $GITHUB_OUTPUT
//           echo "apk_path=$APK_PATH" >> $GITHUB_OUTPUT

//       - name: Gather commit info
//         id: commit_info
//         run: |
//           COMMIT=$(git rev-parse HEAD)
//           MESSAGE=$(git log -1 --pretty=%B | tr -d '\n')
//           DATE=$(git log -1 --pretty=%cd --date=short)
//           COMMITTER=$(git log -1 --pretty=%an)
//           TAG=$(git describe --tags --exact-match $COMMIT 2>/dev/null || echo null)
//           IS_RELEASE=false
//           if [ "$TAG" != "null" ]; then IS_RELEASE=true; fi

//           echo "commit=$COMMIT" >> $GITHUB_OUTPUT
//           echo "commitMessage=$MESSAGE" >> $GITHUB_OUTPUT
//           echo "date=$DATE" >> $GITHUB_OUTPUT
//           echo "committer=$COMMITTER" >> $GITHUB_OUTPUT
//           echo "tag=$TAG" >> $GITHUB_OUTPUT
//           echo "isRelease=$IS_RELEASE" >> $GITHUB_OUTPUT

//       - name: Calculate size diff
//         id: size_diff
//         run: |
//           JSON_FILE="docs/app_size.json"
//           if [ ! -f "$JSON_FILE" ]; then echo "[]" > "$JSON_FILE"; fi
//           PREV_SIZE=$(jq '.[0].size // 0' "$JSON_FILE")
//           CURR_SIZE=${{ steps.apk_size.outputs.apk_size }}
//           SIZE_DIFF=$((CURR_SIZE - PREV_SIZE))
//           echo "prev_size=$PREV_SIZE" >> $GITHUB_OUTPUT
//           echo "size_diff=$SIZE_DIFF" >> $GITHUB_OUTPUT

//       - name: Update app_size.json
//         run: |
//           JSON_FILE="docs/app_size.json"

//           jq --arg commit "${{ steps.commit_info.outputs.commit }}" \
//              --arg commitMessage "${{ steps.commit_info.outputs.commitMessage }}" \
//              --arg date "${{ steps.commit_info.outputs.date }}" \
//              --argjson size ${{ steps.apk_size.outputs.apk_size }} \
//              --argjson sizeDiff ${{ steps.size_diff.outputs.size_diff }} \
//              --arg committer "${{ steps.commit_info.outputs.committer }}" \
//              --arg isRelease "${{ steps.commit_info.outputs.isRelease }}" \
//              '. + [{
//                 commit: $commit,
//                 commitMessage: $commitMessage,
//                 date: $date,
//                 size: $size,
//                 sizeDiff: $sizeDiff,
//                 committer: $committer,
//                 isRelease: ($isRelease == "true")
//              }]' "$JSON_FILE" > tmp.json && mv tmp.json "$JSON_FILE"

//       - name: Commit and push app_size.json
//         uses: stefanzweifel/git-auto-commit-action@v5
//         with:
//           commit_message: "chore: update app_size.json [ci skip]"
//           file_pattern: docs/app_size.json
