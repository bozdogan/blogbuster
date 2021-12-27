const express = require("express");
const postRoutes = require("./post");

const router = express.Router();
router.use("/post", postRoutes);
module.exports = router;