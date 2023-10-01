import React, { useEffect, useState } from "react";
import { useParams } from 'react-router-dom';
import { Paper, styled, useTheme } from "@mui/material";

// MUI
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';

export const Advert = ({ api }: { api: any }) => {
  const theme = useTheme();
  const { hash } = useParams();
  const [advert, setAdvert] = useState({});

  const handleUpdate = ( upd: any) => {
    setAdvert(upd.find(u => u.hash === hash))      
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/adverts', event: handleUpdate } )
    }
    init();
  }, []);

  return (
    <Paper>
      <Typography variant="h2">
        Advert ...{hash.split(".")[5]}
      </Typography>
      <Typography variant="h5">
        Tags: {advert.tags?.join(", ")}
      </Typography>
      <Typography variant="p">
        Description: {advert.description}
      </Typography>
      <br/>
      <Button variant="contained" onClick={()=>console.log("I'm committing!")}>
        Commit
      </Button>
    </Paper>
  )
}

