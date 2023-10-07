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
  const [votes, setVotes] = useState([] as any[]);
  const [intents, setIntents] = useState([] as any[]);
  const [commits, setCommits] = useState([] as any[]);
  const [reviews, setReviews] = useState([] as any[]);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);

  const updateAdvert = ( upd: any) => {
    console.log(`Got advert update:`, upd)
    setAdvert(upd.adverts.find(u => u.hash === hash))      
  }

  const updateVotes = (upd: any) => {
    const filteredVotes = upd.votes.filter(vote =>
      vote.body.advert === hash
    )
    console.log(`Relevant votes:`, filteredVotes)
    setVotes(filteredVotes)
  }

  const updateReviews = (upd: any) => {
    console.log(`Got reviews update:`, upd)
    const filteredIntents = upd.intents.filter(intent =>
      intent.body.advert === hash
    )
    console.log(`Relevant intents:`, filteredIntents)
    setIntents(filteredIntents)

    const filteredCommits = upd.commits.filter(commit =>
        commit.intent.advert === hash
    )
    console.log(`Relevant commits:`, filteredCommits)
    setCommits(filteredCommits)

    const filteredReviews = upd.reviews.filter(review =>
      review.commit.intent.advert === hash
    )
    console.log(`Relevant reviews:`, filteredReviews)
    setReviews(filteredReviews)

  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/json/adverts', event: updateAdvert } )
      api.subscribe( { app: "bizbaz", path: '/json/votes', event: updateVotes } )
      api.subscribe( { app: "bizbaz", path: '/json/reviews', event: updateReviews } )
    }
    init();
  }, []);

  const upvote = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'vote-action',
        json: { 
          'upvote': { 
            advert: hash
          }
        }
      })
  }

  const downvote = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'vote-action',
        json: { 
          'downvote': { 
            advert: hash
          }
        }
      })
  }

  const unvote = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'vote-action',
        json: { 
          'unvote': { 
            advert: hash
          }
        }
      })
  }

  const intent = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'intent': { 
            advert: hash
          }
        }
      })
  }

  const commit = () => {
      const intent = intents[0]?.hash
      if (!intent) {
          console.log(`No intent exists to commit to`)
          return
      }
      console.log(`Committing to intent ${intent}`)
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'commit': { intent }
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

      <Button variant="contained" disabled={votes.length !== 0}onClick={upvote} sx={{ m:2 }}>
        Up Vote
      </Button>

      <Button variant="contained" disabled={votes.length !== 0}onClick={downvote} sx={{ m:2 }}>
        Down Vote
      </Button>

      <Button variant="contained" disabled={votes.length === 0} onClick={unvote} sx={{ m:2 }}>
        Un Vote
      </Button>

      <br/>
      <Button variant="contained" disabled={intents.length !== 0} onClick={intent} sx={{ m:2 }}>
        Express Intent to Buy
      </Button>
      <Button variant="contained" disabled={intents.length === 0 || commits.length !== 0} onClick={commit} sx={{ m:2 }}>
        Commit to Sell
      </Button>
      <br/>
      <Button variant="contained" disabled={commits.length === 0} onClick={()=>setOpenNewReviewDialog(true)} sx={{ m:2 }}>
        Review
      </Button>
      <br/>

      <Typography variant="body1">
        Voted by: {votes.map(r => r.sig.ship).join(", ")}
      </Typography>

      <Typography variant="body1">
        Intents to buy by: {intents.map(i => i.client.ship).join(", ")}
      </Typography>

      <Typography variant="body1">
        Commitments to sell by: {commits.map(c => c.vendor.ship).join(", ")}
      </Typography>

      <Typography variant="body1">
        Reviews by: {reviews.map(r => r.reviewer.ship).join(", ")}
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
        commit={commits[0]}
        reviewee={advert?.vendor?.ship || null}
        open={openNewReviewDialog}
        handleCloseDialog={() => setOpenNewReviewDialog(false)}
        api={api}
      />

    </Paper>
  )} else return (
    <CircularProgress color="inherit" />
  )
}
