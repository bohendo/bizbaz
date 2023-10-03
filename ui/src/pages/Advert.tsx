import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

// MUI
import { useTheme } from "@mui/material/styles"
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import Fab from '@mui/material/Fab'
import { TAdvert } from "../types";

// Icons
import EditIcon from '@mui/icons-material/Edit';

export const Advert = ({ api }: { api: any }) => {
  const theme = useTheme();
  const { hash } = useParams();
  const [advert, setAdvert] = useState({} as TAdvert);
  const [reports, setReports] = useState([] as any[]);

  const updateAdvert = ( upd: any) => {
    setAdvert(upd.find(u => u.hash === hash))      
  }

  const updateReports = (upd: any) => {
    const filteredReports = upd.reports.filter(report =>
      report.body.advert === hash
    )
    console.log(`Relevant reports:`, filteredReports)
    setReports(filteredReports)
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/adverts', event: updateAdvert } )
      api.subscribe( { app: "bizbaz", path: '/reports', event: updateReports } )
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

  const commit = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'commit': { 
            advert: hash
          }
        }
      })
  }

  console.log(advert);

  if (advert === undefined) {
    // TODO: create error 404 not found page
    return <div> Advert does not exist </div>
  } else if (advert) {
    return (
    <Paper variant="outlined" sx={{ p: 8, m: 8 }}>
      <Typography variant="h2">
        Advert ...{hash.split(".")[5]}
      </Typography>
      <Typography variant="h5">
        Tags: {advert.tags?.join(", ")}
      </Typography>
      <Typography variant="body1">
        Description: {advert.description}
      </Typography>
      <br/>
      <Button variant="contained" onClick={report} sx={{ m:2 }}>
        Report
      </Button>
      <Button variant="contained" onClick={commit} sx={{ m:2 }}>
        Commit
      </Button>
      <Button variant="contained" onClick={()=>console.log("I'm reviewing!")} sx={{ m:2 }}>
        Review
      </Button>
      <br/>
      <Typography variant="body1">
        Reported by: {reports.map(r => r.sig.ship).join(", ")}
      </Typography>
      <Fab color='primary' sx={{
        position: 'fixed',
        right: theme.spacing(4),
        bottom: theme.spacing(3)
      }} onClick={() => console.log(`edit advert ${JSON.stringify(advert)}`)}>
        <EditIcon />
      </Fab>
    </Paper>
  )} else return (
    <CircularProgress color="inherit" />
  )
}