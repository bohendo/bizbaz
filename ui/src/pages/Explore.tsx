import React, { useContext, useEffect, useState } from "react";
import { Box, styled, useTheme } from "@mui/material";
import { Link } from "react-router-dom";

import { BizbazContext } from "../BizbazContext"

// types
import { TAdvert } from "../types";

// MUI
import Button from "@mui/material/Button";
import Card from "@mui/material/Card";
import CardActionArea from "@mui/material/CardActionArea";
import CardContent from "@mui/material/CardContent";
import Chip from "@mui/material/Chip";
import Typography from '@mui/material/Typography';
import Masonry from "@mui/lab/Masonry";
import Paper from "@mui/material/Paper";

import { AdvertCard } from "../components/AdvertCard";
import { Sigil } from "../components/Sigil";

const Item = styled(Paper)(({ theme }) => ({
  padding: theme.spacing(3),
  textAlign: 'center',
}))

export const Explore = () => {
  const theme = useTheme();
  const bizbaz = useContext(BizbazContext)
  const { adverts } = bizbaz

  console.log(`Rendering ${adverts.length} adverts`)

  if(adverts.length == 0) return (
    <Typography>
      Loading
    </Typography>
  )

  const config = {
    point: '~talsyx-talsud', // or 'zod'
    size: 24,
    detail:'default',
    space:'none',
  }
  return (
    <Box sx={{width: "100%", mt: theme.spacing(10)}}>
      <Typography variant="h2">
        Adverts
      </Typography>
      <Masonry columns={3} spacing={2}>
        {adverts.map((advert: TAdvert, index: number) => {
          // TODO set itemHeight based on cover image
          return (
            <AdvertCard key={index} advert={advert}/>
          )
        })}
      </Masonry>
    </Box>
  )
}
