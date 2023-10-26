import React, { useContext, useEffect, useState } from "react";
import { Link } from "react-router-dom";

// MUI
import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardActionArea from "@mui/material/CardActionArea";
import CardContent from "@mui/material/CardContent";
import Chip from "@mui/material/Chip";
import Masonry from "@mui/lab/Masonry";
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import { styled, useTheme } from "@mui/material/styles";

// context
import { BizbazContext } from "../BizbazContext"

// types
import { Advert } from "../types";

// components
import { Sigil } from "../components/Sigil";

const StyledDiv = styled("div")(({ theme }) => ({
  width: "100%",
  height: "210px",
}))

const StyledCardImg = styled("img")(( { theme }) => ({
  height: "auto",
  maxWidth: "100%",
}));

export const AdvertCard = ({
  advert
}: { advert: Advert }) => {
  const theme = useTheme();
  // TODO set itemHeight based on cover image
  const [imgError, setImgError] = useState(false);
  const itemHeight = imgError ? 200 : 400; 
  const descriptionCutOff = 60; 
  return (
    <Card sx={{ marginTop: theme.spacing(1) , height: itemHeight, width: 200 }}>
      <CardActionArea disableRipple
        sx={{ width: "100%", alignItems: "center" }}
        component={Link} to={`/advert/${advert.hash}`}>
        <Box sx={{display: 'flex', }}>
          <Sigil config={{ point: advert.vendor.ship, size: 60, detail: 'default', space: 'large' }}/>
          <Typography variant="body1" sx={{ mx: 4, mt: 2 }}>
            {advert.body.title}
          </Typography>
        </Box>
        {advert.body.cover && !imgError?
          <StyledDiv>
            <StyledCardImg
              src={advert.body.cover}
              onError={() => setImgError(true)}
            />
          </StyledDiv>
          : null}


        <CardContent
          sx={{
            backgroundColor: (theme) => theme.palette.mode === "light"
              ? "rgba(256, 256, 256, 0.90)"
              : "rgba(66,  66,  66,  0.90)",
            opacity: "0.99",
            height: "420px",
          }}>

            <Typography variant="caption">
              Vendor: {advert.vendor.ship}
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

