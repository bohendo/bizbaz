import React, { useContext, useEffect, useState, useReducer } from "react";
import { Outlet } from "react-router-dom";

import { BizbazContext } from "./BizbazContext"

// Components
import { NavBar } from "./components/Navbar";

// MUI 
import CssBaseline from "@mui/material/CssBaseline";
import { ThemeProvider } from "@mui/material/styles";
import { darkTheme, lightTheme } from "./styles";

const savedTheme = localStorage.getItem("theme") || "";

export const App = ({ api }: { api: any }) => {
  const [theme, setTheme] = useState(savedTheme === "dark" || savedTheme === "" ? darkTheme : lightTheme);
  const bizbaz = useContext(BizbazContext)

  const [adverts, setAdverts] = useState([] as Array<TAdvert>);
  const [votes, setVotes] = useState([] as Array<TVote>);
  const [intents, setIntents] = useState([] as Array<TIntent>);
  const [commits, setCommits] = useState([] as Array<TCommit>);
  const [reviews, setReviews] = useState([] as Array<TReview>);

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/json/adverts', event: updateAdverts } )
      api.subscribe( { app: "bizbaz", path: '/json/votes', event: updateVotes } )
      api.subscribe( { app: "bizbaz", path: '/json/reviews', event: updateReviews } )
    }
    init();
  }, []);

  const updateAdverts = ( upd: any) => {
    console.log(`Got advert update:`, upd)
    if (upd.gather) {
      setAdverts(upd.gather.adverts || [] as Array<TAdvert>)
    } else if (upd.create) {
      setAdverts((oldAdverts: Array<TAdvert>) => [upd.create.advert, ...oldAdverts])
    } else {
      console.log(`TODO: implement missing advert update:`, upd)
    }
  }

  const updateVotes = (upd: any) => {
    if (upd.gather) {
      setVotes(upd.gather.votes)
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
    // const filterIntents = (ints) => ints.filter(i => i.body.advert === hash)
    // const filterCommits = (cmts) => cmts.filter(c => c.intent.advert === hash)
    // const filterReviews = (revs) => revs.filter(r => r.commit.intent.advert === hash)
    console.log(`Got reviews update:`, upd)
    if (!!upd.gather) {
      setIntents(upd.gather.intents)
      setCommits(upd.gather.commits)
      setReviews(upd.gather.reviews)
      // const { intents, commits, reviews } = upd.gather
      // const filteredIntents = filterIntents(intents)
      // console.log(`Relevant intents:`, filteredIntents)
      // setIntents(filteredIntents)
      // const filteredCommits = filterCommits(commits)
      // console.log(`Relevant commits:`, filteredCommits)
      // setCommits(filteredCommits)
      // const filteredReviews = filterReviews(reviews)
      // console.log(`Relevant reviews:`, filteredReviews)
      // setReviews(filteredReviews)
    } else if (!!upd.intent) {
      console.log("Got new intent:", upd)
      setIntents((oldIntents) => [upd.intent, ...oldIntents])
    } else if (!!upd.commit) {
      console.log("Got new commit:", upd)
      setCommits((oldCommits) => [upd.commit, ...oldCommits])
    } else if (!!upd.review) {
      console.log("Got new review:", upd)
      setReviews((oldReviews) => [upd.review, ...oldReviews])
    } else if (!!upd.update) {
      console.log("Got updated review:", upd)
      setReviews((oldReviews) => {
        oldRev = upd.oldRev
        newRev = upd.newRev
        oldIdx = oldReviews.findIndex(r => r.hash == oldRev)
        if (oldIdx === -1) {
          console.log(`Uhh, no existing review matches this update.. Adding it as if it were a new review`)
          return [newRev, ...newReviews]
        }
        return [
          ...oldReviews.slice(0, oldIdx),
          newRev,
          ...oldReviews.slice(oldIdx + 1)
        ]
      })
    } else {
      console.log("Unknown review updates. Got: ", upd)
    }
  }

  const toggleTheme = () => {
    if (theme.palette.mode === "dark") {
      localStorage.setItem("theme", "light");
      setTheme(lightTheme);
    } else {
      localStorage.setItem("theme", "dark");
      setTheme(darkTheme);
    }
  };

  return (
    <BizbazContext.Provider value={{
      adverts: adverts,
      votes: votes,
      intents: intents,
      commits: commits,
      reviews: reviews,
    }}>
      <ThemeProvider theme={theme}>
          <CssBaseline />
          <NavBar api={api} tabPage={<Outlet />}/>
      </ThemeProvider>
    </BizbazContext.Provider>
  );
}
