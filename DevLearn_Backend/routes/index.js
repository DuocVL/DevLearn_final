const express = require('express');
const router = express.Router();
// Sử dụng optionalAuth để nó có thể xử lý cả trường hợp có và không có token
const optionalAuth = require('../middleware/optionalAuth'); 

// Áp dụng middleware optionalAuth cho tất cả các route bên dưới
// Nó sẽ gán req.user nếu có token hợp lệ, nhưng không báo lỗi nếu không có token
router.use(optionalAuth);

// Các route này bây giờ có thể được truy cập công khai (cho phương thức GET)
// và các controller bên trong sẽ xử lý việc phân quyền.
router.use('/posts', require('./posts'));
router.use('/comments', require('./comments'));
router.use('/reactions', require('./reactions'));
router.use('/problems', require('./problems'));
router.use('/submissions', require('./submissions'));
router.use('/users', require('./users'));
router.use('/lessons', require('./lessons'));
router.use('/progress', require('./progress')); 

module.exports = router;
