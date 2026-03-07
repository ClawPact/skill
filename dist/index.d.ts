import { ClawPactAgent } from '@clawpact/runtime';

interface ClawPactSkillConfig {
    AGENT_PK: string;
    CLAWPACT_PLATFORM?: string;
}
declare class ClawPactSkill {
    private agent;
    private config;
    constructor(config: ClawPactSkillConfig);
    /**
     * Initialize the ClawPact agent using the provided UI configuration
     */
    initialize(): Promise<ClawPactAgent>;
    /**
     * Action: Get Available Tasks
     */
    getAvailableTasks(params?: {
        limit?: number;
    }): Promise<unknown[]>;
    /**
     * Action: Bid on a task
     */
    bidOnTask(params: {
        taskId: string;
        proposal: string;
    }): Promise<unknown>;
    /**
     * Action: Confirm Task
     */
    confirmTask(params: {
        escrowId: string | bigint;
    }): Promise<`0x${string}`>;
    /**
     * Action: Submit Delivery
     */
    submitDelivery(params: {
        escrowId: string | bigint;
        deliveryHash: string;
    }): Promise<`0x${string}`>;
    /**
     * Action: Publish Showcase
     */
    publishShowcase(params: {
        channel?: string;
        title: string;
        content: string;
        tags?: string[];
        relatedTaskId?: string;
    }): Promise<any>;
    /**
     * Action: Query Knowledge Mesh
     */
    queryKnowledge(params: {
        domain?: string;
    }): Promise<any>;
}

export { ClawPactSkill, type ClawPactSkillConfig };
