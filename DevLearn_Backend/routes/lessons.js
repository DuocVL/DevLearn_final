const express = require('express');
const router = express.Router();
const lessonsController = require('../controllers/lessonsController');
const verifyJWT = require('../middleware/verifyJWT');

// Lấy thông tin chi tiết của MỘT bài học (bao gồm cả content)
// Route này sẽ được client gọi khi người dùng click vào một bài học cụ thể.
// Dùng optionalAuth vì có thể người dùng chưa đăng nhập vẫn xem được bài preview
router.get('/:lessonId', lessonsController.handlerGetLessonDetails);

// Cập nhật một lesson cụ thể (yêu cầu đăng nhập và có quyền)
router.put('/:lessonId', verifyJWT, lessonsController.handlerUpdateLesson);

// Xóa một lesson cụ thể (yêu cầu đăng nhập và có quyền)
router.delete('/:lessonId', verifyJWT, lessonsController.handlerDeleteLesson);

module.exports = router;
