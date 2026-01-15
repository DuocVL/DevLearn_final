const mongoose = require('mongoose');
const Tutorials = require('../models/Tutorials');
const Lessons = require('../models/Lessons');

// @desc    Admin tạo một lesson mới cho một tutorial
// @route   POST /api/tutorials/:tutorialId/lessons
// @access  Admin
const handlerCreateLesson = async (req, res) => {
    try {
        if (req.user.role !== 'admin') { // Sửa: Dùng role
            return res.status(403).json({ message: "Not authorized" });
        }

        const { tutorialId } = req.params;
        if (!mongoose.Types.ObjectId.isValid(tutorialId)) {
            return res.status(400).json({ message: "Invalid Tutorial ID" });
        }

        const tutorial = await Tutorials.findById(tutorialId);
        if (!tutorial) {
            return res.status(404).json({ message: "Tutorial not found" });
        }

        const { title, content, videoUrl, duration, isPreviewable } = req.body;
        if (!title || !content || !duration) {
            return res.status(400).json({ message: "Title, content, and duration are required" });
        }

        const newLesson = await Lessons.create({ title, content, videoUrl, duration, isPreviewable: isPreviewable || false, tutorialId });

        // Thêm lesson mới vào danh sách của tutorial
        tutorial.lessons.push(newLesson._id);
        await tutorial.save();

        return res.status(201).json({
            message: "Lesson created and added to tutorial successfully",
            data: newLesson
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: "Internal server error" });
    }
};

// @desc    Admin cập nhật một lesson
// @route   PUT /api/lessons/:lessonId
// @access  Admin
const handlerUpdateLesson = async (req, res) => {
    try {
        if (req.user.role !== 'admin') { // Sửa: Dùng role
            return res.status(403).json({ message: "Not authorized" });
        }

        const { lessonId } = req.params;
        if (!mongoose.Types.ObjectId.isValid(lessonId)) {
            return res.status(400).json({ message: "Invalid Lesson ID" });
        }

        const { title, content, videoUrl, duration, isPreviewable } = req.body;
        const updates = { title, content, videoUrl, duration, isPreviewable };
        Object.keys(updates).forEach(key => updates[key] === undefined && delete updates[key]);

        if (Object.keys(updates).length === 0) {
            return res.status(400).json({ message: "No update fields provided" });
        }

        const updatedLesson = await Lessons.findByIdAndUpdate(lessonId, updates, { new: true });

        if (!updatedLesson) {
            return res.status(404).json({ message: "Lesson not found" });
        }

        return res.status(200).json({
            message: "Lesson updated successfully",
            data: updatedLesson
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: "Internal server error" });
    }
};

// @desc    Admin xóa một lesson
// @route   DELETE /api/lessons/:lessonId
// @access  Admin
const handlerDeleteLesson = async (req, res) => {
    try {
        if (req.user.role !== 'admin') { // Sửa: Dùng role
            return res.status(403).json({ message: "Not authorized" });
        }

        const { lessonId } = req.params;
        if (!mongoose.Types.ObjectId.isValid(lessonId)) {
            return res.status(400).json({ message: "Invalid Lesson ID" });
        }

        const lesson = await Lessons.findById(lessonId);
        if (!lesson) {
            return res.status(404).json({ message: "Lesson not found" });
        }

        // Xóa lessonId khỏi tutorial chứa nó
        await Tutorials.findByIdAndUpdate(lesson.tutorialId, { $pull: { lessons: lessonId } });

        // Xóa lesson
        await Lessons.findByIdAndDelete(lessonId);

        return res.status(200).json({ message: "Lesson deleted successfully" });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: "Internal server error" });
    }
};


// @desc    Lấy danh sách lessons của một tutorial (chỉ metadata)
// @route   GET /api/tutorials/:tutorialId/lessons
// @access  Public
const handlerGetLessonsForTutorial = async (req, res) => {
    try {
        const { tutorialId } = req.params;
        if (!mongoose.Types.ObjectId.isValid(tutorialId)) {
            return res.status(400).json({ message: "Invalid Tutorial ID" });
        }

        // Chỉ populate các trường cần thiết, loại bỏ 'content'
        const tutorial = await Tutorials.findById(tutorialId)
            .populate({
                path: 'lessons',
                select: 'title duration isPreviewable createdAt'
            });

        if (!tutorial || tutorial.hidden) {
            // Kiểm tra xem user có phải admin không để cho phép xem khóa học ẩn
            if (!req.user || req.user.role !== 'admin') {
                 return res.status(404).json({ message: "Tutorial not found" });
            }
        }

        return res.status(200).json({ data: tutorial.lessons });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: "Internal server error" });
    }
};

// @desc    Lấy chi tiết một lesson (bao gồm cả content)
// @route   GET /api/lessons/:lessonId
// @access  Public (với logic kiểm tra)
const handlerGetLessonDetails = async (req, res) => {
    try {
        const { lessonId } = req.params;
        if (!mongoose.Types.ObjectId.isValid(lessonId)) {
            return res.status(400).json({ message: "Invalid Lesson ID" });
        }

        const lesson = await Lessons.findById(lessonId).populate('tutorialId', 'hidden');
        if (!lesson || (lesson.tutorialId.hidden && (!req.user || req.user.role !== 'admin'))) {
            return res.status(404).json({ message: "Lesson not found" });
        }

        // Ai cũng có thể xem chi tiết bài học preview
        if (lesson.isPreviewable) {
            return res.status(200).json({ data: lesson });
        }

        // Nếu không phải preview, kiểm tra người dùng đã đăng nhập chưa
        if (!req.user) {
            return res.status(401).json({ message: "Authentication required to view this lesson" });
        }
        
        // TODO: Thêm logic kiểm tra xem người dùng đã mua khóa học hay chưa
        // Hiện tại, chỉ cần đăng nhập là xem được

        return res.status(200).json({ data: lesson });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: "Internal server error" });
    }
}

module.exports = { 
    handlerCreateLesson, 
    handlerUpdateLesson, 
    handlerDeleteLesson, 
    handlerGetLessonsForTutorial,
    handlerGetLessonDetails // Thêm hàm mới
};