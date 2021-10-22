import { Row, Col } from "antd";
import styled from "styled-components";
import { useState, useEffect } from "react";
import axios from "axios";
import Card from "../components/card";
import Link from "next/link";

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

export default function Home({ data }) {
  const [cards, setCards] = useState([]);

  useEffect(() => {
    let cards = [];
    data.forEach((element) => {
      cards.push(element);
    });

    setCards(cards);
  }, [data]);

  return (
    <div>
      <Row justify={"center"}>
        <Col span={24}>
          <Link href={"/"}>
            <Logo src={"/logo.jpg"} alt="logo" />
          </Link>

          <HeaderH1>
            <NeonRed>이러다가는 </NeonRed>
            <NeonBlue>다죽어 ~</NeonBlue>
          </HeaderH1>
        </Col>
      </Row>
      <Row gutter={16}>
        {cards.map((value) => (
          <Col span={6}>
            <Card key={value._id} identity={value._id} data={value.blocks} />
          </Col>
        ))}
      </Row>
    </div>
  );
}

// This gets called on every request
export async function getServerSideProps() {
  const API_ENDPOINT =
    process.env.REACT_APP_API_ENDPOINT || "http://localhost:6449";
  // Fetch data from external API
  try {
    const { data } = await axios.get(`${API_ENDPOINT}/editorjs`);
    // Pass data to the page via props
    return { props: { data } };
  } catch (e) {
    // Pass data to the page via props
    return { props: { data: [] } };
  }
}
