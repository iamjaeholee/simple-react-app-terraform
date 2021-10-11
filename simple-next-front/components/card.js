import React, { useEffect, useState } from "react";
import parse from "html-react-parser";
import Link from "next/link";
import styled from "styled-components";
import { Button } from "antd";

const CardDiv = styled.div`
  min-width: 20rem !important;
`;

const CardBodyDiv = styled.div``;

function Card(props) {
  const [paragraph, setParagraph] = useState("");
  const [header, setHeader] = useState("");
  const [thumbnail, setThumbnail] = useState("");

  // get Paragraph
  useEffect(() => {
    for (const [key, value] of Object.entries(props.data)) {
      if (header === "" && value.type === "header") {
        try {
          setHeader(parse(value.data.text));
        } catch (e) {
          console.log(e);
          setHeader("");
        }
      }
      if (paragraph === "" && value.type === "paragraph") {
        try {
          setParagraph(parse(value.data.text));
        } catch (e) {
          console.log(e);
          setParagraph("");
        }
      }
      if (thumbnail === "" && value.type === "image")
        setThumbnail(value.data.file.url);
    }
  }, []);

  return (
    <CardDiv>
      <img
        src={thumbnail}
        className="card-img-top"
        alt="..."
        onError={(e) => (e.target.style.opacity = 0)}
      />
      <CardBodyDiv>
        <h5 className="card-title">{header}</h5>
        <p className="card-text">{paragraph}</p>
        <Link href={`/spec/${props.identity}`}>
          <Button>달고나</Button>
        </Link>
      </CardBodyDiv>
    </CardDiv>
  );
}

export default Card;
