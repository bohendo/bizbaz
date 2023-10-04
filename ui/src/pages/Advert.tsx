import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

// Pages
import { NewAdvert } from "../pages/NewAdvert";

// MUI
import { useTheme } from "@mui/material/styles"
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import Fab from '@mui/material/Fab'

import { TAdvert } from "../types";

import { NewReview } from "./NewReview";

// Icons
import EditIcon from '@mui/icons-material/Edit';

export const Advert = ({ api }: { api: any }) => {
  const theme = useTheme();
  const { hash } = useParams();
  const [advert, setAdvert] = useState({} as TAdvert);
  const [reports, setReports] = useState([] as any[]);
  const [commits, setCommits] = useState([] as any[]);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);

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

  const updateReviews = (upd: any) => {
    console.log(`Got reviews update:`, upd)
    const filteredCommits = upd.commits.filter(commit =>
      commit.advert === hash
    )
    console.log(`Relevant commits:`, filteredCommits)
    setCommits(filteredCommits)
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/adverts', event: updateAdvert } )
      api.subscribe( { app: "bizbaz", path: '/reports', event: updateReports } )
      api.subscribe( { app: "bizbaz", path: '/reviews', event: updateReviews } )
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
      <Button variant="contained" onClick={()=>setOpenNewReviewDialog(true)} sx={{ m:2 }}>
        Review
      </Button>
      <br/>

      <Typography variant="body1">
        Reported by: {reports.map(r => r.sig.ship).join(", ")}
      </Typography>

      <Typography variant="body1">
        Commited to by: {commits.map(c => c["client-sig"].ship).join(", ")}
      </Typography>

      <Fab color='primary' sx={{
        position: 'fixed',
        right: theme.spacing(4),
        bottom: theme.spacing(3)
      }} onClick={() => setOpenNewAdvertDialog(true)}>
        <EditIcon />
      </Fab>

      <NewAdvert
        editAdvert={{
          title: advert.title,
          hash: advert.hash,
          tags: advert.tags,
          description: advert.description,
          cover: advert.cover
        }}
        edit={true}
        open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
        api={api}
      /> 

      <NewReview
        advert={hash}
        reviewee={advert?.sig?.ship || null}
        open={openNewReviewDialog}
        handleCloseDialog={() => setOpenNewReviewDialog(false)}
        api={api}
      />

    </Paper>
  )} else return (
    <CircularProgress color="inherit" />
  )
}
