import { Row, Col, Button } from "antd";
import styled from "styled-components";
import Link from "next/link";
import { useCallback, useEffect } from "react";
import { useMemo, useRef } from "react";
import axios from "axios";
import { useState } from "react";

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

const Div = styled.div`
  text-align: center;
`;

export default function Editor() {
  const API_ENDPOINT = useMemo(
    () => process.env.REACT_APP_API_ENDPOINT || "http://localhost:6449",
    []
  );
  const [editor, setEditor] = useState(null);
  let editorJs;

  const elmtRef = useRef();

  useEffect(async () => {
    if (!elmtRef.current) {
      return;
    }

    (async () => {
      const { default: EditorJS } = await import("@editorjs/editorjs");
      const { default: Header } = await import("@editorjs/header");
      const { default: ImageTool } = await import("@editorjs/image");
      const { default: Embed } = await import("@editorjs/embed");
      const { default: Quote } = await import("@editorjs/quote");
      const { default: Marker } = await import("@editorjs/marker");
      const { default: Delimiter } = await import("@editorjs/delimiter");
      const { default: Table } = await import("@editorjs/table");
      const { default: List } = await import("@editorjs/list");

      editorJs = new EditorJS({
        tools: {
          table: {
            class: Table,
            inlineToolbar: true,
            config: {
              rows: 2,
              cols: 3,
            },
          },
          delimiter: Delimiter,
          marker: Marker,
          quote: Quote,
          embed: Embed,
          header: {
            class: Header,
            inlineToolbar: true,
          },
          list: {
            class: List,
            inlineToolbar: true,
          },
          image: {
            class: ImageTool,
            config: {
              endpoints: {
                byFile: `${API_ENDPOINT}/editorjs/uploadFile`, // Your backend file uploader endpoint
                byUrl: `${API_ENDPOINT}/editorjs/uploadFile`, // Your endpoint that provides uploading by Url
              },
            },
          },
        },
        holder: elmtRef.current,
      });
    })().catch((error) => console.error(error));

    setEditor(editorJs);

    return () => {
      editorJs.destroy();
    };
  }, []);

  const handleClick = useCallback((e) => {
    e.preventDefault();

    editorJs
      .save()
      .then((outputData) => {
        axios({
          method: "post",
          url: `${API_ENDPOINT}/editorjs`,
          data: outputData,
        })
          .then(function (response) {
            console.log(response);
          })
          .catch(function (error) {
            console.log(error);
          });
      })
      .catch((error) => {
        console.log("Saving failed: ", error);
      });
  }, []);

  return (
    <div>
      <Row justify={"center"}>
        <Col span={24}>
          <Logo src={"/logo.jpg"} alt="logo" />
          <HeaderH1>
            <NeonRed>이러다가는 </NeonRed>
            <NeonBlue>다죽어 ~</NeonBlue>
          </HeaderH1>
        </Col>
      </Row>
      <Row gutter={16}>
        <Col
          span={24}
          ref={(elmt) => {
            elmtRef.current = elmt;
          }}
        ></Col>
        <Col span={24}>
          <Div>
            <Button type="primary" onClick={handleClick}>
              assign
            </Button>
            <Link href="/">
              <Button>back</Button>
            </Link>
          </Div>
        </Col>
      </Row>
    </div>
  );
}
