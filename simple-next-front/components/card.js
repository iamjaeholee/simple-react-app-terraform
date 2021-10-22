import React, { useEffect, useState } from "react";
import parse from "html-react-parser";
import Link from "next/link";
import styled from "styled-components";
import { Button, Card } from "antd";

const CardThumbnail = styled.img`
  width: 100%;
  height: 20vh;
`;

const { Meta } = Card;

function CardComponent(props) {
  const [paragraph, setParagraph] = useState("이름없는 설명");
  const [header, setHeader] = useState("이름없는 제목");
  const [thumbnail, setThumbnail] = useState("/logo.jpg");

  // get Paragraph
  useEffect(() => {
    for (const [key, value] of Object.entries(props.data)) {
      if (header === "이름없는 제목" && value.type === "header") {
        try {
          setHeader(parse(value.data.text));
        } catch (e) {
          console.log(e);
          setHeader("이름없는 제목");
        }
      }
      if (paragraph === "이름없는 설명" && value.type === "paragraph") {
        try {
          setParagraph(parse(value.data.text));
        } catch (e) {
          console.log(e);
          setParagraph("이름없는 설명ㅁ");
        }
      }
      if (thumbnail === "/logo.jpg" && value.type === "image")
        setThumbnail(value.data.file.url);
    }
  }, []);

  return (
    <Link href={`/spec/${props.identity}`}>
      <Card
        hoverable
        cover={
          <CardThumbnail
            src={thumbnail}
            className="card-img-top"
            alt="..."
            onError={(e) => (e.target.style.opacity = 0)}
          />
        }
      >
        <Meta title={header} description={paragraph} />
      </Card>
    </Link>
    // <CardDiv>
    //   <img
    //     src={thumbnail}
    //     className="card-img-top"
    //     alt="..."
    //     onError={(e) => (e.target.style.opacity = 0)}
    //   />
    //   <CardBodyDiv>
    //     <h5 className="card-title">{header}</h5>
    //     <p className="card-text">{paragraph}</p>
    //     <Link href={`/spec/${props.identity}`}>
    //       <Button>달고나</Button>
    //     </Link>
    //   </CardBodyDiv>
    // </CardDiv>
  );
}

export default CardComponent;
