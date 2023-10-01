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
  const [reports, setReports] = useState([] as any[]);

  const updateAdvert = ( upd: any) => {
    setAdvert(upd.find(u => u.hash === hash))      
  }

  const updateReports = (upd: any) => {
    console.log(`Reports update:`, upd)
    const filteredReports = upd.reports.filter(report =>
      report.body.advert === hash
    )
    console.log(`Filtered reports:`, filteredReports)
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
      <Button variant="contained" onClick={commit} sx={{ m:2 }}>
        Commit
      </Button>
      <Button variant="contained" onClick={()=>console.log("I'm reviewing!")} sx={{ m:2 }}>
        Review
      </Button>
      <br/>
      <Typography variant="p">
        Reported by: {reports.map(r => r.sig.ship).join(", ")}
      </Typography>
    </Paper>
  )
}

