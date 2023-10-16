import { createContext } from 'react';

import { TAdvert, TCommit, TIntent, TReview, TVote } from "./types";

export const BizbazContext = createContext({
  adverts: [] as Array<TAdvert>,
  votes: [] as Array<TVote>,
  intents: [] as Array<TIntent>,
  commits: [] as Array<TCommit>,
  reviews: [] as Array<TReview>,
});
