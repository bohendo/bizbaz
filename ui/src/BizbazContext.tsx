import { createContext } from 'react';

import { TAdvert, TCommit, TIntent, TReview, TVote } from "./types";

interface BizbazContextType {
  adverts: Array<TAdvert>;
  votes: Array<TVote>;
  intents: Array<TIntent>;
  commits: Array<TCommit>;
  reviews: Array<TReview>;
}

export const BizbazContext = createContext<BizbazContextType>({} as BizbazContextType);