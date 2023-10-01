import React from 'react';
import ReactDOM from 'react-dom';
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import './index.css';

// Urbit
import Urbit from "@urbit/http-api";

import { App } from './app';
import { Advert } from './pages/Advert';

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

const router = createBrowserRouter([
  {
    path: "/",
    element: <App api={api} />,
  }, {
    path: "/advert/:hash",
    element: <Advert api={api} />,
  },
], { basename: "/apps/bizbaz" });

ReactDOM.render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
  document.getElementById('app')
);
