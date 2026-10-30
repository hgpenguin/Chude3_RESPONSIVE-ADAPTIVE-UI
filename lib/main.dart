import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveDemoApp());
}

class ResponsiveDemoApp extends StatelessWidget {
  const ResponsiveDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Chủ đề 3: Responsive & Adaptive UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SimpleResponsiveDemo(),
    );
  }
}

class SimpleResponsiveDemo extends StatefulWidget {
  const SimpleResponsiveDemo({super.key});

  @override
  State<SimpleResponsiveDemo> createState() => _SimpleResponsiveDemoState();
}

class _SimpleResponsiveDemoState extends State<SimpleResponsiveDemo> {
  int _selectedIndex = 0;

  // Ngưỡng Breakpoint chuẩn Material 3 (600px) phân tách Compact và Medium
  static const double kBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    // Lấy chiều rộng toàn màn hình
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isWideScreen = screenWidth >= kBreakpoint;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text(
          'MediaQuery: ${screenWidth.toInt()} px — '
          '${isWideScreen ? "Rộng (≥ 600)" : "Hẹp (< 600)"}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Màn hình hẹp (< 600px): Sử dụng thanh điều hướng ở đáy
      bottomNavigationBar: isWideScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Cá nhân',
                ),
              ],
            ),

      body: Row(
        children: [
          // Màn hình rộng (>= 600px): Sử dụng thanh điều hướng bên trái
          if (isWideScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Trang chủ'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Cá nhân'),
                ),
              ],
            ),

          if (isWideScreen) const VerticalDivider(width: 1, thickness: 1),

          // Vùng hiển thị nội dung
          Expanded(
            child: _selectedIndex == 0
                ? LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Đo chiều rộng thực tế còn trống mà vùng nội dung được cấp
                      final double availableWidth = constraints.maxWidth;

                      return Column(
                        children: [
                          // Thanh trạng thái giúp đối chiếu MediaQuery và LayoutBuilder khi Demo
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            color: Colors.amber.shade100,
                            child: Text(
                              'Không gian khả dụng (LayoutBuilder): ${availableWidth.toInt()} px '
                              '-> Bố cục: ListView (1 cột)',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Expanded(
                            child: _buildListView(),
                          ),
                        ],
                      );
                    },
                  )
                : _buildProfilePage(),
          ),
        ],
      ),
    );
  }

  // Bố cục 1: Danh sách dọc (ListView) cho không gian khả dụng hẹp (< 500px)
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text('${index + 1}'),
            ),
            title: Text(
              'Mục dữ liệu số ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Hiển thị dạng danh sách dọc 1 cột (ListView)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      },
    );
  }

  // Tab Cá nhân
  Widget _buildProfilePage() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Trang cá nhân',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chuyển tab bằng menu đáy (màn hẹp) hoặc menu trái (màn rộng)',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
