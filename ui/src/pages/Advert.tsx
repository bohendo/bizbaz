import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

// Pages
import { NewAdvert } from "../pages/NewAdvert";

// MUI
import { useTheme } from "@mui/material/styles"
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import Fab from '@mui/material/Fab'

import { TAdvert, TCommit, TIntent, TReview, TVote } from "../types";

import { NewReview } from "./NewReview";

// Icons
import EditIcon from '@mui/icons-material/Edit';

export const Advert = ({ api }: { api: any }) => {
  const theme = useTheme();
  const { hash } = useParams();
  const navigate = useNavigate();
  const [advert, setAdvert] = useState({} as TAdvert);
  const [votes, setVotes] = useState([] as any[]);
  const [intents, setIntents] = useState([] as any[]);
  const [commits, setCommits] = useState([] as any[]);
  const [reviews, setReviews] = useState([] as any[]);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);

  const updateAdvert = ( upd: any) => {
    console.log(`Got advert update:`, upd)
    if (upd.gather) {
      setAdvert(upd.gather.adverts.find((u: TAdvert) => u.hash === hash))      
    } else if (upd.update) {
      navigate(`advert/${upd.update.update.new.hash}`)
    } else {
      console.log(`Got unknown advert update:`, upd)
    }
  }

  const updateVotes = (upd: any) => {
    if (upd.gather) {
      const filteredVotes = upd.gather.votes.filter((vote: TVote) =>
        vote.body.advert === hash
      )
      console.log(`Relevant votes:`, filteredVotes)
      setVotes(filteredVotes)
    } else if (upd.vote) {
      const newVote = upd.vote
      console.log(`New vote:`, newVote)
      setVotes((oldVotes) => {
        const recast = oldVotes.findIndex(v =>
          v.body.advert === newVote.body.advert && v.body.voter === newVote.body.voter
        )
        console.log(`recast index:`, recast)
        if (recast === -1) {
          console.log(`This is a new vote, adding it to the array`)
          return [...oldVotes, newVote]
        } else {
          console.log(`This is a recast vote, updating the previous vote to ${newVote.choice}`)
          if (newVote.body.choice === "un") {
            return [...oldVotes.slice(0, recast), ...oldVotes.slice(recast + 1)]
          } else {
            return [...oldVotes.slice(0, recast), newVote, ...oldVotes.slice(recast + 1)]
          }
        }
      })
    } else {
      console.log(`Got unknown vote update:`, upd)
    }
  }

  const updateReviews = (upd: any) => {
    console.log(`Got reviews update:`, upd)
    const filteredIntents = upd.intents.filter((intent: TIntent) =>
      intent.body.advert === hash
    )
    console.log(`Relevant intents:`, filteredIntents)
    setIntents(filteredIntents)

    const filteredCommits = upd.commits.filter((commit: TCommit) =>
        commit.intent.advert === hash
    )
    console.log(`Relevant commits:`, filteredCommits)
    setCommits(filteredCommits)

    const filteredReviews = upd.reviews.filter((review: TReview) =>
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

  const vote = (choice: string) => {
      api.poke({
        app: 'bizbaz',
        mark: 'vote-action',
        json: { 
          'vote': { 
            advert: hash,
            choice: choice
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
  } else if (advert.body) {
    return (
    <Paper variant="outlined" sx={{ p: 8, m: 8 }}>
      <Typography variant="h2">
        {advert.body.title}
      </Typography>
      <Typography variant="caption">
        Posted by: {advert.vendor.ship}
      </Typography>
      <Typography variant="h5">
        Tags: {advert.body.tags?.join(", ")}
      </Typography>
      <Typography variant="body1">
        Description: {advert.body.description}
      </Typography>
      <br/>

      <Button variant="contained" disabled={votes.length === 1 && votes[0].body.choice === "up"}onClick={() => vote("up")} sx={{ m:2 }}>
        Up Vote
      </Button>

      <Button variant="contained" disabled={votes.length === 1 && votes[0].body.choice === "down"}onClick={() => vote("down")} sx={{ m:2 }}>
        Down Vote
      </Button>

      <Button variant="contained" disabled={votes.length === 0} onClick={() => vote("un")} sx={{ m:2 }}>
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
        Voted by: {votes.map(v => v.voter.ship).join(", ")}
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
          hash: advert.hash,
          body: {
            title: advert.body.title,
            tags: advert.body.tags,
            description: advert.body.description,
            cover: advert.body.cover,
            when: Date.now()
          }
        }}
        edit={true}
        open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
        api={api}
      /> 

      <NewReview
        commit={commits[0]}
        reviewee={advert?.vendor?.ship || ""}
        open={openNewReviewDialog}
        handleCloseDialog={() => setOpenNewReviewDialog(false)}
        api={api}
      />

    </Paper>
  )} else return (
    <CircularProgress color="inherit" sx={{margin: theme.spacing(16)}} />
  )
}
