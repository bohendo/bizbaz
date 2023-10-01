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

  const report = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'report-action',
        json: { 
          'snitch': { 
            advert: hash
          }
        }
      })
  }

  return (
    <Paper sx={{ p: 8, m: 8 }}>
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
      <Button variant="contained" onClick={report} sx={{ m:2 }}>
        Report
      </Button>
      <Button variant="contained" onClick={()=>console.log("I'm committing!")} sx={{ m:2 }}>
        Commit
      </Button>
      <Button variant="contained" onClick={()=>console.log("I'm reviewing!")} sx={{ m:2 }}>
        Review
      </Button>
    </Paper>
  )
}

