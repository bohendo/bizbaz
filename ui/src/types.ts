export type TAdvertValidation = {
    hasError: boolean;
    errorMsgs: {
        coverError: string;
        descriptionError: string;
        tagsError: string;
        titleError: string;
    }
}

export type TAdvertBody = {
    cover: string;
    description: string;
    tags: Array<string>;
    title: string;
    when: number;
}

export type TNewAdvert = {
    hash?: string;
    body: TAdvertBody;
}

export type TAdvert = {
    hash: string;
    body: TAdvertBody;
    vendor: TSignature;
}

export type TSignature = {
    life: string;
    ship: string;
    sig: string;
};

export type TVote = {
    hash: string;
    body: {
        advert: string;
        choice: string;
        voter: string;
        when: number;
    };
    voter: TSignature;
}

export type TIntentBody = {
    advert: string;
    vendor: TSignature;
    client: string;
    when: number;
}

export type TCommitBody = {
    intent: string;
    client: TSignature;
    vendor: string;
    when: number;
}

export type TReviewBody = {
    commit: string;
    reviewee: string;
    score: number;
    why: string;
    when: number;
}

export type TIntent = {
    hash: string;
    client: TSignature;
    body: TIntentBody;
};

export type TCommit = {
    hash: string;
    vendor: TSignature;
    intent: TIntentBody;
    body: TCommitBody;
};

export type TReview = {
    hash: string;
    reviewer: TSignature;
    body: TReviewBody;
    commit: TCommit;
};
