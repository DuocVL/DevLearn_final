const express = require('express');
const router = express.Router();
const { handlerAddPost, handlerUpdatePost, handlerDeletePost, handlerGetPost, handleGetListPost } = require('../controllers/postsController');
const verifyJWT = require('../middleware/verifyJWT'); // Import middleware verifyJWT

// Các route CÔNG KHAI (không cần token)
// GET /posts -> Lấy danh sách tất cả bài viết
router.get('/', handleGetListPost);

// GET /posts/some-post-id -> Lấy chi tiết một bài viết
router.get('/:postId', handlerGetPost);


// Các route BẢO VỆ (yêu cầu token hợp lệ)

// POST /posts -> Tạo bài viết mới
router.post('/', verifyJWT, handlerAddPost);

// PATCH /posts/some-post-id -> Cập nhật bài viết
router.patch('/:postId', verifyJWT, handlerUpdatePost);

// DELETE /posts/some-post-id -> Xóa bài viết
router.delete('/:postId', verifyJWT, handlerDeletePost);


module.exports = router;
