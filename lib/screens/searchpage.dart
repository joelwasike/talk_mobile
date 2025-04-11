import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/utils/error_handler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../resources/searchpostpage.dart';
import '../widgets/followerspeople.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: LightColor.scaffold,
          automaticallyImplyLeading: false,
          title: const TabBar(
            unselectedLabelStyle: TextStyle(fontSize: 15),
            indicatorPadding: EdgeInsets.only(bottom: 10),
            labelColor: LightColor.background,
            indicatorColor: LightColor.maincolor,
            dividerColor: LightColor.scaffold,
            tabs: [
              Tab(text: 'Photos'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PinterestGrid(),
            FriendsTab(),
          ],
        ),
      ),
    );
  }
}

class PinterestGrid extends StatefulWidget {
  const PinterestGrid({Key? key}) : super(key: key);

  @override
  State<PinterestGrid> createState() => _PinterestGridState();
}

class _PinterestGridState extends State<PinterestGrid>
    with AutomaticKeepAliveClientMixin {
  final List<Map<String, dynamic>> _data = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _setupSearchListener();
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _performSearch(_searchController.text);
      });
    });
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await http.get(Uri.parse('$baseUrl/getposts'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _data.clear();
          _data.addAll(jsonData.cast<Map<String, dynamic>>());
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _error = e.toString());
      ErrorHandler.showError(context, 'Failed to load posts');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = null;
      });
      return;
    }

    try {
      setState(() {
        _isSearching = true;
        _error = null;
      });

      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        body: jsonEncode({'searchstring': query}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _data.clear();
          _data.addAll(jsonData.cast<Map<String, dynamic>>());
        });
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _error = e.toString());
      ErrorHandler.showError(context, 'Search failed');
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          hintText: "Search posts...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 20,
          ),
          suffixIcon: _isSearching
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
          filled: true,
          fillColor: LightColor.scaffold,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_data.isEmpty) {
      return Center(
        child: Text(
          _isSearching ? 'Searching...' : 'No posts found',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: StaggeredGrid.count(
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        crossAxisCount: 3,
        children: _data.map((item) => _buildGridItem(item)).toList(),
      ),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> item) {
    return StaggeredGridTile.fit(
      crossAxisCellCount: 1,
      child: GestureDetector(
        onTap: () => _openPostDetails(item),
        child: Hero(
          tag: item["id"],
          child: ImageCard(imageData: item["media"]),
        ),
      ),
    );
  }

  void _openPostDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPostPage(postId: item["id"]),
      ),
    );
  }
}

class ImageCard extends StatefulWidget {
  const ImageCard({Key? key, required this.imageData}) : super(key: key);

  final String imageData;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  VideoPlayerController? _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  bool isVideoLink(String link) {
    final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.wmv'];
    for (final extension in videoExtensions) {
      if (link.toLowerCase().endsWith(extension)) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (isVideoLink(widget.imageData)) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.imageData));
      _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isVideo = isVideoLink(widget.imageData);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: isVideo
          ? FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                      Center(
                        child: Icon(
                          Icons.play_arrow,
                          size: 48,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: Container());
                }
              },
            )
          : CachedNetworkImage(
              imageUrl: widget.imageData,
              fit: BoxFit.cover,
              placeholder: (context, url) => GFShimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      color: Colors.grey.shade800.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class FriendsTab extends StatefulWidget {
  const FriendsTab({Key? key}) : super(key: key);

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> data = [];
  bool isloading = false;
  String? campus = "";
  String? email = "";
  int? id = 0;
  String? media = "";
  String? username = "";
  final TextEditingController searchController =
      TextEditingController(); // Add this line

  //fetchdata
  Future<void> fetchData() async {
    try {
      setState(() {
        isloading = true;
      });
      var box = Hive.box("Talk");
      var id = box.get("id");
      final url =
          Uri.parse('$baseUrl/getusers/$id'); // Replace with your JSON URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
        });

        // Now you can access the data as needed.
        for (final item in data) {
          campus = item['campus'];
          email = item['email'];
          id = item['ID'];
          media = item['profile_picture'];
          username = item['username'];
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  //search endpoint
  Future<void> search(String query) async {
    if (query.isEmpty) {
      // clearGrid(); // Clear the grid when the search query is empty
      return;
    }

    try {
      setState(() {
        isloading = true;
      });

      final url = Uri.parse(
          '$baseUrl/searchusers/$id'); // Modify the URL to your search endpoint
      final response = await http.post(
        url,
        body: jsonEncode({
          'searchstring': query
        }), // Send the query as JSON in the request body
        headers: {
          'Content-Type': 'application/json'
        }, // Specify the content type
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  // Function to clear the grid
  void clearGrid() {
    setState(() {
      data.clear();
    });
  }

  void getid() {
    var box = Hive.box("Talk");
    setState(() {
      id = box.get("id");
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(() {
      search(searchController.text);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 6, right: 2),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
              hintText: "Search friends...",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
                size: 20,
              ),
              filled: true,
              fillColor: LightColor.scaffold,
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   (context),
                    //   MaterialPageRoute(builder: (context) =>  ChatPagee(name: people[index])

                    //       ),
                    // );
                  },
                  child: PeopleFCard(
                      image: data[index]["profile_picture"],
                      name: data[index]["username"],
                      school: data[index]["campus"],
                      id: data[index]["ID"],
                      email: data[index]["email"],
                      isfollowing: data[index]["following"]));
            },
          ),
        ),
      ],
    );
  }
}
