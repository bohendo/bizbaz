import { createContext } from 'react';

import { Advert, Commit, Intent, Review, Vote } from "./types";

interface BizbazContextType {
  adverts: Array<Advert>;
  votes: Array<Vote>;
  intents: Array<Intent>;
  commits: Array<Commit>;
  reviews: Array<Review>;
}

export const BizbazContext = createContext<BizbazContextType>({} as BizbazContextType);
