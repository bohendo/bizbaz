import React, { useEffect, useState } from "react";
import { Box, styled, useTheme } from "@mui/material";
import { Link } from "react-router-dom";

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

import '@urbit/sigil-js'

const Item = styled(Paper)(({ theme }) => ({
  padding: theme.spacing(3),
  textAlign: 'center',
}))

export const Adverts = ({
  api
}: { api: any }) => {
  const theme = useTheme();
  const [adverts, setAdverts] = useState([]);


  const handleUpdate = ( upd: any) => {
    setAdverts(upd)      
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/adverts', event: handleUpdate } )
    }
    init();
  }, []);

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
    <Box>
      <Typography variant="h2">
        Adverts
      </Typography>
      <Masonry columns={3} spacing={2}>
        {adverts.map((advert: TAdvert, index: number) => {
          // TODO set itemHeight based on cover image
          const itemHeight = advert.description.length < 60 ? 200 : 260; 
          const descriptionCutOff = 60; 
          return (
            <Card key={index} sx={{ marginTop: theme.spacing(1) , height: itemHeight, width: 100 }}>
              <CardActionArea disableRipple
                sx={{ width: "100%", alignItems: "center" }}
                component={Link} to={`/advert/${advert.hash}`}>
                <urbit-sigil point={advert.vendor} size={60} detail='default' space='large'/>

                <CardContent
                  sx={{
                    backgroundColor: (theme) => theme.palette.mode === "light"
                      ? "rgba(256, 256, 256, 0.90)"
                      : "rgba(66,  66,  66,  0.90)",
                    opacity: "0.99",
                    height: "420px",
                  }}>

                    <Typography variant="body2">
                      {advert.title}
                    </Typography>

                    <Typography variant="caption" display="block">
                      Cover image: {advert.cover}
                    </Typography>

                    <Typography variant="caption" display="block">
                      Tags: {advert.tags.join(", ")}
                    </Typography>

                    <Typography variant="caption" marginTop={theme.spacing(1)}>
                      {advert.description.substring(0, descriptionCutOff)}
                    </Typography>

                </CardContent>

              </CardActionArea>

              <Button variant="contained" onClick={()=>console.log(`Omg I'm committing`)}>
                Commit
              </Button>

            </Card>
          )
        })}
      </Masonry>
    </Box>
  )
}

