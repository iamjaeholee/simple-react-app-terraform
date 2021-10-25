const express = require("express");
const router = express.Router();
const multer = require("multer");
const multerS3 = require("multer-s3");
const aws = require("aws-sdk");
const S3 = new aws.S3({});

S3.listBuckets((err, data) => {
  console.log(data);
  if (err) console.log(err.message);
});

const MONGODB_PATH = process.env.MONGODB_PATH || "mongodb://localhost:27017";

/**
 * mongoose setup
 */

const mongoose = require("mongoose");
try {
  mongoose.connect(`${MONGODB_PATH}/squid`, {
    useNewUrlParser: true,
    // useUnifiedTopology: true,
  });
} catch (e) {
  console.log(e);
}

const Data = mongoose.model("Data", {
  blocks: Object,
});

/**
 * uploadFile endpoint
 */

const upload = multer({
  storage: multerS3({
    s3: S3,
    bucket: process.env.BUCKET || "squid-game",
    acl: "public-read",
  }),
});

router.post("/uploadFile", upload.any(), function (req, res, next) {
  console.log("router come in");
  console.log(req.files);
  res.send({
    success: 1,
    file: {
      url: req.files[0].location,
    },
  });
});

/**
 * EditorJS endpoint
 */

router.post("/", function (req, res, next) {
  let editorData;
  try {
    editorData = new Data({ blocks: req.body.blocks });
  } catch (e) {
    console.log(e);
  }

  console.log(req.body);

  editorData
    .save()
    .then(() => {
      console.log("saving successful");
      res.send("saving successful");
    })
    .catch((error) => {
      console.log(error);
      res.send("saving failed");
    });
});

/**
 * EditorJS get Data
 */
router.get("/", async function (req, res, next) {
  Data.find({}, (err, data) => {
    if (err) {
      console.log(err);
      res.status(500).send(err);
    }
    res.status(200).send(data);
  });
});

router.get("/one", async function (req, res, next) {
  const _id = req.query.id;

  try {
    const result = await Data.findById(_id).lean().exec();
    res.send(result);
  } catch (e) {
    console.log(e);
  }
});

router.delete("/delete", async function (req, res, next) {
  const _id = req.query.id;

  try {
    const result = await Data.findById(_id).remove().exec();
    res.send(result);
  } catch (e) {
    console.log(e);
  }
});

module.exports = router;
