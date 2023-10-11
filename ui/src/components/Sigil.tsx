import React from 'react';
import '@urbit/sigil-js'

interface SigilConfig {
  point?: string;
  size?: number;
  foreground?: string;
  background?: string;
  space?: string;
  detail?: string;
}

interface UrbitSigilProps extends React.HTMLAttributes<HTMLElement>, SigilConfig {}
declare global {
  namespace JSX {
    interface IntrinsicElements {
      'urbit-sigil': React.DetailedHTMLProps<UrbitSigilProps, HTMLElement>;
    }
  }
}

const defaultConfig: SigilConfig = {
  point: '~talsyx-talsud',
  size: 24,
  foreground: "#eee",
  background: "#111",
  space: 'none',
  detail: 'default',
}

export const Sigil = (props: { config: SigilConfig }) => {
  const {
    point, size, foreground, background, space, detail
  } = { ...defaultConfig, ...props.config };
  return (
    <urbit-sigil point={point} size={size} foreground={foreground} background={background} space={space} detail={detail} />
  )
};
