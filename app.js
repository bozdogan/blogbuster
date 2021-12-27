const path = require("path");
const express = require("express");
const expressSession = require("express-session");
const mongoose = require("mongoose");
const apiRoutes = require("./api/v1");

const PORT = 3001;
const DB_URL = "mongodb://127.0.0.1:27017/blogbuster";
const SESSION_SECRET = "itsnotasecret";

mongoose.connect(DB_URL)
    .then(() => {
        console.log("DATABASE CONNECTED");
    })
    .catch(err => {
        console.log("DATABASE ERROR::");
        console.log(err);
    });


const app = express();

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

app.use(express.static(path.join(__dirname, "static")));
app.use(express.urlencoded({extended: true}));
app.use(expressSession({
    secret: SESSION_SECRET,
    resave: false,
    saveUninitialized: false
}));

app.use("/api", apiRoutes);
app.get("/", (req, res) => {
    res.render("index")
});

app.listen(PORT, () => {
    console.log(`Listening on port ${PORT}`);
});
