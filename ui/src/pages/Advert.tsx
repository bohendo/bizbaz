import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

// Components
import { Votes } from '../components/Votes';
import { Intents } from '../components/Intents';
import { CommitCard } from "../components/CommitCard";

// Pages
import { NewAdvert } from "../pages/NewAdvert";

// MUI
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import Fab from '@mui/material/Fab'
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import { useTheme } from "@mui/material/styles"

import { TAdvert, TCommit, TIntent, TReview, TVote } from "../types";

import { NewReview } from "./NewReview";

// Icons
import EditIcon from '@mui/icons-material/Edit';

export const Advert = ({ api }: { api: any }) => {
  const theme = useTheme();
  const { hash } = useParams();
  const navigate = useNavigate();
  const [advert, setAdvert] = useState({} as TAdvert);
  const [votes, setVotes] = useState([] as Array<TVote>);
  const [ourVote, setOurVote] = useState({} as TVote);
  const [intents, setIntents] = useState([] as Array<TIntent>);
  const [commits, setCommits] = useState([] as Array<TCommit>);
  const [reviews, setReviews] = useState([] as any[]);
  const [reviewCommit, setReviewCommit] = useState<TCommit | undefined>(undefined);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);

  console.log(advert)
  const updateAdvert = ( upd: any) => {
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
    if (!!upd.gather) {
      const { intents, commits, reviews } = upd.gather
      const filteredIntents = intents.filter((intent: TIntent) =>
        intent.body.advert === hash
      )
      console.log(`Relevant intents:`, filteredIntents)
      setIntents(filteredIntents)

      const filteredCommits = commits.filter((commit: TCommit) =>
          commit.intent.advert === hash
      )
      console.log(`Relevant commits:`, filteredCommits)
      setCommits(filteredCommits)

      const filteredReviews = reviews.filter((review: TReview) =>
        review.commit.intent.advert === hash
      )
      console.log(`Relevant reviews:`, filteredReviews)
      setReviews(filteredReviews)
    } else {
      console.log("TODO: handle other review updates. Got: ", upd)
    }

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

  const doReview = (commit: TCommit) => {
    setReviewCommit(commit)
    setOpenNewReviewDialog(true)
  }

  if (advert === undefined) {
    // TODO: create error 404 not found page
    return <div> Advert does not exist </div>
  } else if (advert.body) {
    return (
      <div>
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

          <Votes votes={votes} vote={vote} />

        </Paper>

        <Intents intents={intents} intent={intent}
          vendor={advert.vendor.ship}
          commits={commits} commit={commit}
        />

        <List>
            {commits.map((commit: TIntent, i) => {
                console.log(`preparing to render commit card for:`, commit);
                return(
                    <ListItem key={i}>
                      <CommitCard
                          commit={commit}
                          vendor={commit.vendor.ship == `~${window.ship}`}
                          doReview={() => doReview(commit)}
                      />
                    </ListItem>
                )
            })}
        </List>

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
          commit={reviewCommit}
          reviewee={advert?.vendor?.ship || ""}
          open={openNewReviewDialog}
          handleCloseDialog={() => setOpenNewReviewDialog(false)}
          api={api}
        />

    </div>
  )} else return (
    <CircularProgress color="inherit" sx={{margin: theme.spacing(16)}} />
  )
}
