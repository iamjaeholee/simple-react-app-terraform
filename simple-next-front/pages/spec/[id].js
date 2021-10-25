import { useEffect, useState } from "react";
import axios from "axios";
import Blocks from "editorjs-blocks-react-renderer";
import { Row, Col } from "antd";
import Link from "next/link";
import styled from "styled-components";

const Logo = styled.img`
  margin-bottom: 2rem;
  height: 8vmin;
  pointer-events: none;

  @media (prefers-reduced-motion: no-preference) {
    animation: App-logo-spin infinite 20s linear;
  }

  @keyframes App-logo-spin {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }
`;

const HeaderH1 = styled.h1`
  text-align: center;
`;

const NeonRed = styled.i`
  --neon: hsl(192 100% 95%);
  --neon-glow: hsl(194 100% 40%);
  color: var(--neon);
  text-shadow: 0 0 20px var(--neon-glow), 0 0 2.5vmin var(--neon-glow),
    0 0 5vmin var(--neon-glow), 0 0 10vmin var(--neon-glow),
    0 0 15vmin var(--neon-glow);
  @media (dynamic-range: high) {
    --neon-glow: color(display-p3 0 0.75 1);

    text-shadow: 0 0 2.5vmin var(--neon-glow), 0 0 10vmin var(--neon-glow),
      0 0 15vmin var(--neon-glow);
  }
`;

const NeonBlue = styled.i`
  --neon: hsl(355 100% 95%);
  --neon-glow: hsl(355 98% 40%);
  color: var(--neon);
  text-shadow: 0 0 20px var(--neon-glow), 0 0 2.5vmin var(--neon-glow),
    0 0 5vmin var(--neon-glow), 0 0 10vmin var(--neon-glow),
    0 0 15vmin var(--neon-glow);
  @media (dynamic-range: high) {
    --neon-glow: color(display-p3 1 0 0);

    text-shadow: 0 0 2.5vmin var(--neon-glow), 0 0 10vmin var(--neon-glow),
      0 0 15vmin var(--neon-glow);
  }
`;

const Post = () => {
  const router = useRouter();
  const { id } = router.query;
  const [data, setData] = useState({});

  useEffect(async () => {
    const API_ENDPOINT =
      process.env.REACT_APP_API_ENDPOINT || "http://localhost:6449";
    // Fetch data from external API
    try {
      const { data } = await axios.get(`${API_ENDPOINT}/editorjs/one`, {
        params: {
          id,
        },
      });

      setData(data);
    } catch (e) {
      console.error(e);
    }
  }, []);

  const [block, setBlock] = useState(null);

  useEffect(() => {
    setBlock(
      <Blocks
        data={data}
        config={{
          code: {
            className: "col editor-code",
          },
          tr: {
            className: "image",
          },
          embed: {
            className: "col editor-embed",
          },
          header: {
            className: "col editor-header",
          },
          image: {
            className: "col editor-image",
          },
          list: {
            className: "col editor-list",
          },
          paragraph: {
            className: "col editor-paragraph",
          },
          quote: {
            className: "col editor-quote",
          },
          table: {
            className:
              "col editor-table table table-striped table-dark table-hover",
          },
        }}
      />
    );
  }, [data]);

  return (
    <div>
      <Row justify={"center"}>
        <Col span={24}>
          <Link href={"/"}>
            <Logo src={"/logo.jpg"} alt="logo" />
          </Link>

          <HeaderH1>
            <NeonRed>나 너무 </NeonRed>
            <NeonBlue>무서워 ㅜㅜ</NeonBlue>
          </HeaderH1>
        </Col>
      </Row>
      <Row gutter={16}>
        <Col span={24}>{block}</Col>
      </Row>
    </div>
  );
};

export default Post;
