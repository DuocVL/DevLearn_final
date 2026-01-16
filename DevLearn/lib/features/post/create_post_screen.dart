import 'package:devlearn/data/repositories/post_repository.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  bool _isAnonymous = false;
  String _status = 'published';
  bool _isLoading = false;

  final _postRepository = PostRepository();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
   
        final tags = _tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();

        await _postRepository.createPost(
          title: _titleController.text,
          content: _contentController.text,
          tags: tags,
          isAnonymous: _isAnonymous,
          status: _status,
        );

       
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng bài viết thành công!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } catch (e) {
        // Hiển thị lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo bài viết mới'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : TextButton(
                    onPressed: _submitPost,
                    child: const Text('ĐĂNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trường nhập tiêu đề
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  hintText: 'Nhập tiêu đề bài viết của bạn',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // Trường nhập nội dung
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  hintText: 'Chia sẻ kiến thức của bạn...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 24),

              // Trường nhập tags
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (thẻ)',
                  hintText: 'ví dụ: flutter, api, javascript',
                  helperText: 'Các tags cách nhau bởi dấu phẩy',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Lựa chọn ẩn danh
              SwitchListTile(
                title: const Text('Đăng với tư cách ẩn danh'),
                value: _isAnonymous,
                onChanged: (bool value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
                secondary: Icon(_isAnonymous ? Icons.visibility_off : Icons.visibility),
              ),
              const Divider(height: 32),

              // Lựa chọn trạng thái (Nháp hoặc Công khai)
              Text('Trạng thái', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              RadioListTile<String>(
                title: const Text('Công khai'),
                subtitle: const Text('Mọi người đều có thể thấy bài viết này'),
                value: 'published',
                groupValue: _status,
                onChanged: (String? value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Lưu nháp'),
                subtitle: const Text('Chỉ mình bạn có thể thấy bài viết này'),
                value: 'draft',
                groupValue: _status,
                onChanged: (String? value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
