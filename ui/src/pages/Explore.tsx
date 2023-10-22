import React, { useContext, useEffect, useState } from "react";
import { Box, styled, useTheme } from "@mui/material";

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

  const config = {
    point: '~talsyx-talsud', // or 'zod'
    size: 24,
    detail:'default',
    space:'none',
  }
  return (
    <Box sx={{width: "100%", mt: theme.spacing(10), minHeight: '100vh' }}>
      <Typography variant="h2">
        Adverts
      </Typography>
      {adverts.length > 0 ?
        <Masonry columns={3} spacing={2}>
          {adverts.map((advert: TAdvert, index: number) => {
            return (
              <AdvertCard key={index} advert={advert}/>
            )
          })}
        </Masonry> :
          <Typography>
            No ads posted or synced to your ship.
            <br />
            <br />
            Click button in the bottom right corner to post a new ad
          </Typography>
      }
    </Box>
  )
}
