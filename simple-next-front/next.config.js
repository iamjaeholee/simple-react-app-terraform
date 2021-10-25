const withBundleAnalyzer = require("@next/bundle-analyzer")({
  enabled: process.env.ANALYZE === "true",
});
module.exports = withBundleAnalyzer({
  reactStrictMode: true,
  env: {
    REACT_APP_API_ENDPOINT:
      "http://squid-lb-backend-218763352.ap-northeast-2.elb.amazonaws.com",
  },
});
