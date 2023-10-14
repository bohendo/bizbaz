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

import { Sigil } from "../components/Sigil";

const Item = styled(Paper)(({ theme }) => ({
  padding: theme.spacing(3),
  textAlign: 'center',
}))

export const AdvertCard = ({
  advert
}: { advert: TAdvert }) => {
  const theme = useTheme();
  // TODO set itemHeight based on cover image
  const itemHeight = advert.body.description.length < 60 ? 200 : 260; 
  const descriptionCutOff = 60; 
  return (
    <Card sx={{ marginTop: theme.spacing(1) , height: itemHeight, width: 100 }}>
      <CardActionArea disableRipple
        sx={{ width: "100%", alignItems: "center" }}
        component={Link} to={`/advert/${advert.hash}`}>
        <Sigil config={{ point: advert.vendor.ship, size: 60, detail: 'default', space: 'large' }}/>

        <CardContent
          sx={{
            backgroundColor: (theme) => theme.palette.mode === "light"
              ? "rgba(256, 256, 256, 0.90)"
              : "rgba(66,  66,  66,  0.90)",
            opacity: "0.99",
            height: "420px",
          }}>

            <Typography variant="body2">
              {advert.body.title}
            </Typography>

            <Typography variant="caption" display="block">
              Cover image: {advert.body.cover}
            </Typography>

            <Typography variant="caption" display="block">
              Tags: {advert.body.tags.join(", ")}
            </Typography>

            <Typography variant="caption" marginTop={theme.spacing(1)}>
              {advert.body.description.substring(0, descriptionCutOff)}
            </Typography>

        </CardContent>

      </CardActionArea>

    </Card>
  )
}

